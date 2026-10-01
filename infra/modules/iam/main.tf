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

resource "aws_iam_role_policy_attachment" "terraform_plan_read_only" {
  role       = aws_iam_role.terraform_plan.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy_document" "terraform_plan_backend" {
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

resource "aws_iam_role_policy" "terraform_plan_backend" {
  name   = "SecureStaticSiteTerraformBackendPolicy"
  role   = aws_iam_role.terraform_plan.id
  policy = data.aws_iam_policy_document.terraform_plan_backend.json
}
