# Create IAM user.
resource "aws_iam_user" "ssm_user" {
  name          = local.ssm_user_name
  path          = "/"
  force_destroy = true

  tags = {
    "Name" = local.ssm_user_name
  }
}