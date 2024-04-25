# --- Outputs for production website ---

output "website_cloudfront_id" {
  description = "Production website Cloudfront distribution ID"
  value       = module.website.website_cloudfront_id
}

output "website_cloudfront_url" {
  description = "Production website Cloudfront distribution URL"
  value       = module.website.website_cloudfront_url
}

output "website_s3_bucket_name" {
  description = "Production website S3 bucket name"
  value       = module.website.website_s3_bucket_name
}

output "website_url" {
  description = "Production website URL"
  value       = module.website.website_url
}

# --- Outputs for test website ---

output "website_test_s3_bucket_name" {
  description = "Test website S3 bucket name"
  value       = module.website.website_test_s3_bucket_name
}

output "website_test_s3_endpoint" {
  description = "Test website S3 endpoint"
  value       = module.website.website_test_s3_endpoint
}

output "website_test_url" {
  description = "Test website URL"
  value       = module.website.website_test_url
}

# --- Outputs for IAM ---

output "aws_region" {
  description = "AWS region used to provision non-global resources such as S3 buckets"
  value       = var.aws_region
}

output "aws_s3_role_arn" {
  description = "ARN for AWS role allowed to upload files to S3 buckets"
  value       = aws_iam_role.s3_role.arn
}
