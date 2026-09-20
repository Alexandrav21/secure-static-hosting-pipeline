module "kms" {
  source = "./modules/kms"

  project_name = var.project_name
}

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