# AWS S3 static website - Terraform root workspace

## Purpose

1. Provisions the required AWS services to host and run a statically-generated website using Terraform Cloud. Resources are included for a production and a test version of the website. Uses the module: [AWS S3 static website - Terraform module](https://github.com/liftconfig/terraform-aws-s3-website)
2. Provisions the AWS IAM user, policy, and role to enable GitHub Actions to sync the generated website files to the production & test S3 buckets and invalidate the CloudFront cache. GitHub actions is run from the website respository: [liftconfig-website](https://github.com/liftconfig/liftconfig-website)

## Prerequisites

- AWS user with permissions to provision the required services
- Domain and hosted zone registered in Route53 matching the domain of the website to be provisioned
- Terraform Cloud account (if TFC is used for provisioning). Refer to [liftconfig-tfc-boostrap](https://github.com/liftconfig/liftconfig-tfc-bootstrap) repository for information on bootstrapping the required GitHub repositories and TFC workspace/modules.

## Input variables

### Required input variables

| Input name                  | Type         | Default value            | Description                                                      |
|:----------------------------|:-------------|:-------------------------|:-----------------------------------------------------------------|
| `aws_region`                | string       | N/A                      | AWS region for S3 buckets                                        |
| `aws_role`                  | string       | N/A                      | AWS role to be assumed to provision resources in this repository |
| `website_domain`            | string       | N/A                      | Website domain name including TLD e.g. mywebsite.com             |
| `website_test_ip_whitelist` | list(string) | N/A                      | IPs allowed to access the test website                           |

### Optional input variables

| Input name                  | Type        | Default value            | Description                                                                          |
|:----------------------------|:------------|:-------------------------|:-------------------------------------------------------------------------------------|
| `aws_s3_policy`             | string      | s3-website-github-policy | Create AWS policy allowing user to assume role to sync files to S3 buckets*          |
| `aws_s3_role`               | string      | s3-website-github-role   | Create AWS role allowing user to sync files to S3 buckets*                           |
| `aws_s3_user`               | string      | s3-website-github-user   | Create AWS user with access to sync files to S3 buckets*                             |
| `cloudfront_default_ttl`    | number      | 86400                    | Default TTL for pages in CloudFront cache                                            |
| `cloudfront_error_page`     | string      | 404.html                 | The object that CloudFront serves when a 404 error is returned                       |
| `cloudfront_price_class`    | string      | PriceClass_100           | Price class for CloudFront (Options: PriceClass_All, PriceClass_200, PriceClass_100) |
| `cloudfront_root_object`    | string      | index.html               | The object that CloudFront serves when the root URL is requested                     |
| `website_tags`              | map(string) | see variables.tf         | Tags for the production website resources                                            |
| `website_test_tags`         | map(string) | see variables.tf         | Tags for the test website resources                                                  |

\* Used by GitHub actions in [liftconfig-website](https://github.com/liftconfig/liftconfig-website) repository to sync website files to S3 buckets

### Environment variables

- `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY` must be configured for the AWS user provisioning the resources
- AWS provider configuration (providers.tf) assumes user will be assuming a role (variable `aws_role`) to gain required permissions. Remove assume role block if this is not the case.

## Output variables

### Production website outputs

| Output Name                  | Description                           |
|:-----------------------------|:--------------------------------------|
| `website_cloudfront_id`      | Cloudfront distribution ID*           |
| `website_cloudfront_url`     | Cloudfront distribution URL           |
| `website_s3_bucket_name`     | S3 bucket hosting website files name* |
| `website_url`                | Production website URL                |

### Test website outputs

| Output Name                   | Description                              |
|:------------------------------|:-----------------------------------------|
| `website_test_s3_bucket_name` | S3 bucket hosting website files name*    |
| `website_test_s3_endpoint`    | S3 bucket hosting website files endpoint |
| `website_test_url`            | Test website URL                         |

### Other outputs

| Output Name       | Description                                             |
|:------------------|:--------------------------------------------------------|
| `aws_region`      | AWS region for S3 buckets*                              |
| `aws_s3_role_arn` | ARN for AWS role allowed to upload files to S3 buckets* |

\*Output is required for GitHub Actions variables used for deployment in the [liftconfig-website](https://github.com/liftconfig/liftconfig-website) repository

## Component diagram

![AWS services component diagram](images/c4-component-aws_services.drawio.svg)
Refer to [Bootstrap repository](https://github.com/liftconfig/liftconfig-tfc-bootstrap) for C4 container diagram
