# --- User, role, and policy for providing access to the websites S3 buckets ---

data "aws_caller_identity" "current" {}

# IAM user
resource "aws_iam_user" "s3_user" {
  name = var.aws_s3_user

  tags = var.website_tags
}

# IAM role
resource "aws_iam_role" "s3_role" {
  name = var.aws_s3_role

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole",
          "sts:TagSession"
        ],
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Condition" : {}
      }
    ]
  })

  inline_policy {
    name = "${var.aws_s3_role}-inline-policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AccessToWebsiteBuckets",
          "Effect" : "Allow",
          "Action" : [
            "s3:PutObject",
            "s3:GetBucketLocation",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:ListBucketVersions",
            "s3:DeleteObject"
          ],
          "Resource" : [
            "${module.website.website_s3_arn}",
            "${module.website.website_s3_arn}/*",
            "${module.website.website_test_s3_arn}",
            "${module.website.website_test_s3_arn}/*"
          ]
        },
        {
          "Sid" : "AccessToCloudfront",
          "Effect" : "Allow",
          "Action" : [
            "cloudfront:GetInvalidation",
            "cloudfront:CreateInvalidation"
          ],
          "Resource" : "${module.website.website_cloudfront_arn}"
        }
      ]
    })
  }

  tags = var.website_tags
}

# IAM policy allowing assuming the role
resource "aws_iam_policy" "s3_policy" {
  name        = var.aws_s3_policy
  description = "Policy allowing the user to assume the role"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole",
          "sts:TagSession"
        ],
        "Resource" : "${aws_iam_role.s3_role.arn}"
      }
    ]
  })

  tags = var.website_tags
}

# Attach the policy to the user
resource "aws_iam_user_policy_attachment" "s3_user" {
  user       = aws_iam_user.s3_user.name
  policy_arn = aws_iam_policy.s3_policy.arn
}