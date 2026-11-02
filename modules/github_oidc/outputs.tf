output "role_arn" {
  description = "ARN of the role GitHub Actions should assume (put this in your workflow)."
  value       = aws_iam_role.deploy.arn
}

output "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC identity provider."
  value       = aws_iam_openid_connect_provider.github.arn
}
