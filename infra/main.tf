module "kms" {
  source = "./modules/kms"

  project_name = var.project_name
}

data "aws_caller_identity" "current" {}

module "s3" {
  source = "./modules/s3"

  project_name     = var.project_name
  kms_key_arn      = module.kms.key_arn
  site_bucket_name = var.site_bucket_name
  log_bucket_name  = var.log_bucket_name
}

module "cloudfront" {
  source = "./modules/cloudfront"

  project_name                     = var.project_name
  site_bucket_arn                  = module.s3.site_bucket_arn
  site_bucket_regional_domain_name = module.s3.site_bucket_regional_domain_name
}

data "aws_iam_policy_document" "kms" {
  statement {
    sid    = "EnableIAMUserPermissions"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }

    actions = [
      "kms:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "AllowCloudFrontServicePrincipalSSEKMS"
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "cloudfront.amazonaws.com",
      ]
    }

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        module.cloudfront.distribution_arn,
      ]
    }
  }
}

resource "aws_kms_key_policy" "this" {
  key_id = module.kms.key_id
  policy = data.aws_iam_policy_document.kms.json
}