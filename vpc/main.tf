# Performs CIDR maths to split given CIDR block into
# four equally sized subnets (two private and two public).
module "subnet_addrs" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = var.base_cidr_block
  networks = [
    {
      name     = "public1"
      new_bits = 2
    },
    {
      name     = "public2"
      new_bits = 2
    },
    {
      name     = "private1"
      new_bits = 2
    },
    {
      name     = "private2"
      new_bits = 2
    },
  ]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.3"

  name = var.solution_name
  cidr = module.subnet_addrs.base_cidr_block

  # Create subnets across two AZs in the desired region.
  azs             = ["${var.region}a", "${var.region}b"]

  # Create NATed private subnets.
  private_subnets = [ 
                      module.subnet_addrs.network_cidr_blocks["private1"],
                      module.subnet_addrs.network_cidr_blocks["private2"]
                    ]
  
  public_subnets =  [ 
                      module.subnet_addrs.network_cidr_blocks["public1"],
                      module.subnet_addrs.network_cidr_blocks["public2"]
                    ]

  # Enable NATing.
  enable_nat_gateway = true
  # Create just one NAT gateway in one AZ.
  single_nat_gateway = true
  enable_vpn_gateway = false

  # Required to use VPC endpoints.
  enable_dns_hostnames = true
  enable_dns_support   = true

  vpc_tags = {
      Name = var.solution_name
  }
}

# Endpoints for SSM over PrivateLink.
# Three endpoints are needed for SSM: SSM, SSM messages and EC2 messages.
module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "3.11.3"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [aws_security_group.vpc_tls.id]

  endpoints = {
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      security_group_ids  = [aws_security_group.vpc_tls.id]
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      security_group_ids  = [aws_security_group.vpc_tls.id]
    },
    ec2messages = {
      service             = "ec2messages"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      security_group_ids  = [aws_security_group.vpc_tls.id]
    },
  }
}

# Allow TLS from within VPC to the endpoints.
resource "aws_security_group" "vpc_tls" {
  name_prefix = "${var.solution_name}-vpc_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

}