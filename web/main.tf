# Get the latest Amazon Linux 2 AMI.
data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  owners = ["137112412989"] # Amazon
}

# Create one or more web servers with across the private
# subnets.
resource "aws_instance" "amazon" {

  count = var.machine_count

  subnet_id     = element(var.web_subnet_ids, count.index)
  ami           = data.aws_ami.amazon.id
  instance_type = var.instance_type

  # Attach SSM IAM profile.
  iam_instance_profile = var.ssm-iam-profile

  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "${var.instance_name}${format("%02d", count.index + 1)}"
  }

  # Configure instance(s) with the contents of ./scripts/install_nginx.sh.
  user_data = filebase64("${path.module}/scripts/install_nginx.sh")
}