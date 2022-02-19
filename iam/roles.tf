# IAM Policy with assume role for EC2.
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Configure IAM role for admin.
resource "aws_iam_role" "ec2_admin" {
  name               = local.ssm_admin_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# Configure IAM instance profile.
resource "aws_iam_instance_profile" "ec2_admin" {
  name = local.ssm_admin_name
  role = aws_iam_role.ec2_admin.name
}