terraform {
  backend "s3" {
    bucket       = "secure-static-site-tfstate-lexi"
    key          = "secure-static-site/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}