module "website" {
  source  = "app.terraform.io/liftconfig/s3-website/aws"
  version = "1.0.0"

  cloudfront_default_ttl    = var.cloudfront_default_ttl
  cloudfront_error_page     = var.cloudfront_error_page
  cloudfront_price_class    = var.cloudfront_price_class
  cloudfront_root_object    = var.cloudfront_root_object
  website_domain            = var.website_domain
  website_tags              = var.website_tags
  website_test_ip_whitelist = var.website_test_ip_whitelist
  website_test_tags         = var.website_test_tags

  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
  }
}