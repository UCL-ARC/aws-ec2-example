# ARNs for all web server EC2 instances.
output "instance_arn" {
  value = module.web-servers.instance_arns
}

# Instance IDs of all web servers.
output "instance_ids" {
  value = module.web-servers.instance_ids
}

# SSM user that can access EC2 instances.
output "ssm_username" {
  value = module.iam.ssm-username
}

# The entry point URL for the application.
output "lb_public_address" {
  value = module.elb_http.elb_dns_name
}