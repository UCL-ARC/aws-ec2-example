variable "region" {
  description = "AWS region"
  default     = "eu-west-2"
}

variable env {
    description = "Environment"
    type        = map(string)
    default = {
        dev = "dev"
        test = "test"
        prod = "prod"
    }
}

# Terraform workspace name for interoperability with Terraform Cloud and
# Terraform CLI. 
#
# If using Terraform cloud, the suffix is used to set the environment tag and 
# subsequently name infrastructure components. E.g. a cloud workspace called 
# 'web-app-dev' will be the tagged as 'dev'. If using the Terraform CLI in 
# workspace 'dev', the environment will be 'dev'.
variable "TFC_WORKSPACE_NAME" {
  type = string
  default = ""
}

variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t2.micro"
}

# Total number of web servers, evenly split across AZs.
variable "num_web_servers" {
  description = "Number of web servers to provision"
  type        = number
  default     = 1 
}

### REQUIRED INPUTS ###

# CIDR to create VPC in. As there are four subnets (2 private; 2 public), the
# smallest acceptable range is /26 because /28 is the smallest allowable subnet
# on AWS.
variable "vpc_cidr_block" {
  description = "VPC CIDR: e.g. 10.0.0.0/26"
  type        = string
}

# Application name prefix.
variable "solution_name" {
  description = "Overall solution name"
}

variable "owner" {
  description = "Solution owner's name"
}

variable "owner_email" {
  description = "Solution owner's email address"
}

variable "AWS_ACCESS_KEY_ID" {
  description = "Access Key for AWS IAM user"
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "Secret Access Key for AWS IAM user"
}
