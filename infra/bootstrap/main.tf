resource "aws_s3_bucket" "terraform_state" {
  #checkov:skip=CKV2_AWS_62:Terraform state does not require S3 event notifications.
  #checkov:skip=CKV_AWS_18:Additional access logging is omitted for the private encrypted Terraform backend.
  #checkov:skip=CKV_AWS_144:Cross-region replication is outside the cost and scope of this short-lived portfolio project.
  #checkov:skip=CKV2_AWS_61:Automatic lifecycle expiration is intentionally omitted to preserve Terraform state history.
  #checkov:skip=CKV_AWS_145:SSE-S3 is an intentional cost choice for the Terraform backend; the bucket remains encrypted.
  bucket = var.state_bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
