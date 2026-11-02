output "bucket_name" {
  description = "Name of the S3 bucket holding the site files."
  value       = aws_s3_bucket.site.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket holding the site files."
  value       = aws_s3_bucket.site.arn
}

output "distribution_id" {
  description = "ID of the CloudFront distribution."
  value       = aws_cloudfront_distribution.site.id
}

output "distribution_arn" {
  description = "ARN of the CloudFront distribution."
  value       = aws_cloudfront_distribution.site.arn
}

output "site_url" {
  description = "HTTPS URL of the site."
  value       = "https://${aws_cloudfront_distribution.site.domain_name}"
}
