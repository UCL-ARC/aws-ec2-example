variable "solution_name" {
  description = "Overall solution name"
  type = string
}

variable "env" {
  description = "Environment abbreviation e.g. dev/test/prod"
  type = string
}

locals {
    ssm_user_name  = "${var.solution_name}-ssm-user-${var.env}"
    ssm_admin_name = "${var.solution_name}-ec2-admin-${var.env}"
}