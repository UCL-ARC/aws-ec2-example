output "ssm-iam-profile" {
  value = aws_iam_role.ec2_admin.name
}

output "ssm-username" {
  value = aws_iam_user.ssm_user.name
}