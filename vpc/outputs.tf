# IDs of the private subnets that will contain the EC2 instances.
output "web_subnet_ids" {
  value = module.vpc.private_subnets
}

# CIDRs of the private subnets that will contain the EC2 instances.
output "web_subnet_cidrs" {
  value = module.vpc.private_subnets_cidr_blocks
}

# IDs of the public subnets for the ELB.
output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

# CIDRs of the public subnets.
output "public_subnet_cidrs" {
  value = module.vpc.public_subnets_cidr_blocks
}

# ID of the created VPC for convenience rather than having to 
# look it up again.
output "vpc_id" {
  value = module.vpc.vpc_id
}