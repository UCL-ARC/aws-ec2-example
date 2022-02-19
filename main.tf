provider "aws" {
  region = var.region

  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY

  default_tags {
    tags = {
      Owner       = var.owner
      Owner_email = var.owner_email
      Terraform   = "true"
      Environment = local.env
    }
  }

}

locals {
  # If your backend is not Terraform Cloud, the value is ${terraform.workspace}
  # otherwise the value retrieved is that of the TFC_WORKSPACE_NAME with trimprefix
  workspace = var.TFC_WORKSPACE_NAME != "" ? trimprefix("${var.TFC_WORKSPACE_NAME}", "aws-ec2-example-") : "${terraform.workspace}"
  env       = var.env[local.workspace]
}

# Configure ec2-admin role and ssm-user IAM user.
module "iam" {
  source = "./iam"

  solution_name = var.solution_name
  env           = local.env
}

# Create the VPC from a given CIDR and name.
# 
# The module creates one NAT gateway (i.e. in a single AZ).
# Be aware that VPC endpoints are created for SSM, SSM messages and EC2 messages to keep 
# all SSM traffic within the AWS network.
module "vpc" {
  source          = "./vpc"
  base_cidr_block = var.vpc_cidr_block
  solution_name   = "${var.solution_name}-${local.env}"
  region          = var.region
}

# Build one or more nginx web servers and attach SSM IAM profile.
module "web-servers" {
  source = "./web"

  machine_count = var.num_web_servers

  instance_name = "${var.solution_name}-web-${local.env}"
  instance_type = var.instance_type

  web_subnet_ids  = module.vpc.web_subnet_ids
  ssm-iam-profile = module.iam.ssm-iam-profile

  security_group_id = aws_security_group.web_sg.id

  depends_on = [module.vpc]
}

# Attach an elastic load balancer (ELB) to public subnets and 
# distribute HTTP traffic to the web server instances in the 
# private subnets.
module "elb_http" {
  source  = "terraform-aws-modules/elb/aws"
  version = "3.0.1"

  name = "${var.solution_name}-elb-${local.env}"

  subnets         = module.vpc.public_subnet_ids
  security_groups = [aws_security_group.vpc_elb.id]
  internal        = false

  listener = [
    {
      instance_port     = 80
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    },
  ]

  health_check = {
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  #access_logs = {
  #  bucket = "elb-access-logs"
  #}

  // ELB attachments
  number_of_instances = var.num_web_servers
  instances           = module.web-servers.instance_ids

}