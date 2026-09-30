run "security_configuration" {
  command = plan

  assert {
    condition     = var.domain_name == "labs.alexandravladu.co.uk"
    error_message = "The configured domain must be labs.alexandravladu.co.uk."
  }

  assert {
    condition     = var.site_bucket_name != ""
    error_message = "The site bucket name must be configured."
  }

  assert {
    condition     = var.log_bucket_name != ""
    error_message = "The log bucket name must be configured."
  }

  assert {
    condition     = var.allowed_countries != null
    error_message = "Allowed countries must be configured."
  }

  assert {
    condition     = var.github_owner != ""
    error_message = "GitHub owner must be configured."
  }

  assert {
    condition     = var.github_repository != ""
    error_message = "GitHub repository must be configured."
  }
}