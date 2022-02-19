# Attach policy to user.
resource "aws_iam_user_policy" "ssm_user" {
  name = local.ssm_user_name
  user = aws_iam_user.ssm_user.name

  policy = file("${path.module}/json-policies/ssm-user.json")
}

# Attach policy to role.
# Policy is same as AmazonSSMManagedInstanceCore.
resource "aws_iam_role_policy" "ec2_admin" {
  name = local.ssm_admin_name
  role = aws_iam_role.ec2_admin.id

  policy = file("${path.module}/json-policies/ec2-admin.json")
}