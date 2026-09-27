resource "aws_s3_bucket" "site" {
  #checkov:skip=CKV2_AWS_62:The static site does not require S3 event notifications.
  #checkov:skip=CKV_AWS_18:The bucket is private and accessed only through CloudFront OAC; S3 server access logging is intentionally omitted.
  #checkov:skip=CKV_AWS_144:Cross-region replication is outside the cost and scope of this short-lived portfolio project.
  #checkov:skip=CKV_AWS_21:S3 object versioning is intentionally omitted for the short-lived deployment bucket.
  #checkov:skip=CKV2_AWS_61:A lifecycle policy is not required for the short-lived site content bucket.
  bucket = var.site_bucket_name
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

resource "aws_s3_bucket" "logs" {
  #checkov:skip=CKV2_AWS_62:The log bucket does not require S3 event notifications.
  #checkov:skip=CKV_AWS_18:The logging destination is not configured to log to itself.
  #checkov:skip=CKV_AWS_144:Cross-region replication is outside the cost and scope of this short-lived portfolio project.
  #checkov:skip=CKV_AWS_21:Object versioning is intentionally omitted because logs already expire after seven days.
  bucket = var.log_bucket_name
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "expire-cloudfront-logs"
    status = "Enabled"

    filter {}

    expiration {
      days = 7
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
