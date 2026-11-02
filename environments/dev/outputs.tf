output "site_url" {
  description = "HTTPS URL of the deployed static site."
  value       = module.static_site.site_url
}

output "site_bucket" {
  description = "S3 bucket holding the site files."
  value       = module.static_site.bucket_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (needed for cache invalidation)."
  value       = module.static_site.distribution_id
}

output "github_deploy_role_arn" {
  description = "Role ARN for GitHub Actions to assume."
  value       = module.github_oidc.role_arn
}

output "vpc_id" {
  description = "ID of the VPC."
  value       = module.network.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = module.network.private_subnet_ids
}
