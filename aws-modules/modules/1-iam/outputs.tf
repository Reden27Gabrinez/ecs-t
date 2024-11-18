output "code_deploy_arn" {
    value = aws_iam_role.code_deploy.arn
}

output "iam_instance_profile_arn" {
  value = aws_iam_instance_profile.this.arn
}

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.this.name
}

output "iam_instance_role" {
  value = aws_iam_role.instance_profile.name
}