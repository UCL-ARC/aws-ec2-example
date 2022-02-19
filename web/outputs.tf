output "instance_arns" {
  value = aws_instance.amazon[*].arn
}

output "instance_ids" {
  value = aws_instance.amazon[*].id
}