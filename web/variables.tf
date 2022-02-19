variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t2.micro"
}

variable "instance_name" {
  description = "EC2 instance name"
}

variable "web_subnet_ids" {
  description = "IDs of the web subnets"
}

variable "ssm-iam-profile" {
  description = "Name of SSM IAM profile"
  type        = string
}

variable "security_group_id" {
  description = "ID of the instance security group"
}

variable "machine_count" {
  description = "Number of web servers to provision"
  type        = number
  default     = 1
}
