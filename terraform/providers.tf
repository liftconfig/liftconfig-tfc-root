terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.41.0"
    }
  }

  required_version = "~> 1.8.0"
}

provider "aws" {
  region = var.aws_region

  assume_role {
    duration = "1h"
    role_arn = var.aws_role
  }
}

# us-east-1 for ACM certificate used by CloudFront
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"

  assume_role {
    duration = "1h"
    role_arn = var.aws_role
  }
}