data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "github_actions_trust" {
  statement {
    effect = "Allow"

    principals {
      type = "Federated"

      identifiers = [
        data.aws_iam_openid_connect_provider.github.arn,
      ]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:${var.github_owner}@122618599/${var.github_repository}@1354663866:ref:refs/heads/${var.github_branch}",
      ]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "SecureStaticSiteGitHubActionsRole"
  assume_role_policy = data.aws_iam_policy_document.github_actions_trust.json
}

data "aws_iam_policy_document" "github_actions_deploy" {
  statement {
    sid    = "ListSiteBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      var.site_bucket_arn,
    ]
  }

  statement {
    sid    = "ManageSiteObjects"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "${var.site_bucket_arn}/*",
    ]
  }

  statement {
    sid    = "UseSiteKMSKey"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
    ]

    resources = [
      var.kms_key_arn,
    ]
  }

  statement {
    sid    = "InvalidateCloudFrontCache"
    effect = "Allow"

    actions = [
      "cloudfront:CreateInvalidation",
    ]

    resources = [
      var.cloudfront_distribution_arn,
    ]
  }
}

resource "aws_iam_role_policy" "github_actions_deploy" {
  name   = "SecureStaticSiteDeploymentPolicy"
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.github_actions_deploy.json
}

data "aws_iam_policy_document" "terraform_plan_trust" {
  statement {
    effect = "Allow"

    principals {
      type = "Federated"

      identifiers = [
        data.aws_iam_openid_connect_provider.github.arn,
      ]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:${var.github_owner}@122618599/${var.github_repository}@1354663866:ref:refs/heads/${var.terraform_plan_branch}",
        "repo:${var.github_owner}@122618599/${var.github_repository}@1354663866:pull_request",
      ]
    }
  }
}

resource "aws_iam_role" "terraform_plan" {
  name               = "SecureStaticSiteTerraformPlanRole"
  assume_role_policy = data.aws_iam_policy_document.terraform_plan_trust.json
}

data "aws_iam_policy_document" "terraform_plan" {
  #checkov:skip=CKV_AWS_356:Read-only Terraform plan role requires wildcard resource scope for AWS discovery APIs; write/state permissions are separately scoped to required resources.

  statement {
    sid    = "ReadTerraformInfrastructure"
    effect = "Allow"

    actions = [
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:ListTagsForCertificate",

      "cloudfront:GetDistribution",
      "cloudfront:ListDistributions",
      "cloudfront:GetOriginAccessControl",
      "cloudfront:GetCachePolicy",
      "cloudfront:ListCachePolicies",
      "cloudfront:GetResponseHeadersPolicy",
      "cloudfront:ListResponseHeadersPolicies",

      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:GetOpenIDConnectProvider",
      "iam:ListOpenIDConnectProviders",

      "kms:DescribeKey",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:ListAliases",
      "kms:ListResourceTags",

      "route53:GetHostedZone",
      "route53:ListResourceRecordSets",
      "route53:ListHostedZones",

      "s3:ListAllMyBuckets",

      "sns:GetTopicAttributes",
      "sns:ListTopics",
      "sns:ListTagsForResource",
      "sns:GetSubscriptionAttributes",

      "cloudwatch:DescribeAlarms",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "ReadProjectBuckets"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketAcl",
      "s3:GetBucketCORS",
      "s3:GetBucketLocation",
      "s3:GetBucketLogging",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetBucketOwnershipControls",
      "s3:GetBucketPolicy",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketRequestPayment",
      "s3:GetBucketTagging",
      "s3:GetBucketVersioning",
      "s3:GetBucketWebsite",
      "s3:GetEncryptionConfiguration",
      "s3:GetLifecycleConfiguration",
      "s3:GetReplicationConfiguration",
      "s3:GetAccelerateConfiguration",
    ]

    resources = [
      var.site_bucket_arn,
      "arn:aws:s3:::secure-static-site-logs-lexi",
    ]
  }

  statement {
    sid    = "ListTerraformStateBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::secure-static-site-tfstate-lexi",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:prefix"

      values = [
        "secure-static-site/terraform.tfstate",
        "secure-static-site/terraform.tfstate.tflock",
      ]
    }
  }

  statement {
    sid    = "ReadWriteTerraformState"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::secure-static-site-tfstate-lexi/secure-static-site/terraform.tfstate",
    ]
  }

  statement {
    sid    = "ManageTerraformStateLock"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::secure-static-site-tfstate-lexi/secure-static-site/terraform.tfstate.tflock",
    ]
  }
}

resource "aws_iam_role_policy" "terraform_plan" {
  name   = "SecureStaticSiteTerraformPlanPolicy"
  role   = aws_iam_role.terraform_plan.id
  policy = data.aws_iam_policy_document.terraform_plan.json
}
