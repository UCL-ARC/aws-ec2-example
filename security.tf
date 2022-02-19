# Security group for the load balancer.
# 
# Inbound: HTTP traffic into the VPC from anywhere.
# Outbound: HTTP traffic to private subnets.
resource "aws_security_group" "vpc_elb" {
  name_prefix = "${var.solution_name}-elb"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "elb_http_ingress" {
  type              = "ingress"
  description       = "HTTP ingress to VPC"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpc_elb.id
}

resource "aws_security_group_rule" "elb_to_private_http_egress" {
  type                     = "egress"
  description              = "HTTP ELB to private"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vpc_elb.id
  source_security_group_id = aws_security_group.web_sg.id
}

# Security group for the EC2 instances.
# 
# Inbound: HTTP traffic from ELB to private subnets.
# Outbound: All to Internet.
resource "aws_security_group" "web_sg" {
  name_prefix = "${var.solution_name}-http-web"
  description = "Allow HTTP traffic from ELB to priv."
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "elb_to_private_http_ingress" {
  type                     = "ingress"
  description              = "HTTP ingress from ELB"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_sg.id
  source_security_group_id = aws_security_group.vpc_elb.id
}

resource "aws_security_group_rule" "private_to_internet_egress" {
  type              = "egress"
  description       = "Return to Internet"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}
