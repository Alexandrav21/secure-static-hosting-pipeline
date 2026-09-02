# Secure Static Hosting Pipeline

A security-first and cost-conscious static website hosting pipeline on AWS, built with Terraform and GitHub Actions.

## Project goals

- Host static content in a private Amazon S3 bucket.
- Encrypt site content and access logs with AWS KMS.
- Deliver content through Amazon CloudFront using Origin Access Control.
- Protect the CloudFront distribution with AWS WAF.
- Deploy infrastructure and site content through secure CI/CD workflows.
- Detect infrastructure drift and monitor operational failures.
- Use a custom domain with HTTPS.
- Keep the deployment inexpensive and easy to destroy.

## Planned architecture

- Amazon S3 private site bucket
- Amazon S3 CloudFront log bucket
- AWS KMS customer-managed encryption key
- Amazon CloudFront distribution
- CloudFront Origin Access Control
- AWS WAF WebACL
- ACM TLS certificate
- Route 53 DNS records
- CloudWatch alarms
- GitHub Actions with AWS OIDC
- Terraform remote state

## Security principles

- No public S3 access
- Least-privilege IAM and resource policies
- No long-lived AWS credentials in GitHub
- Encryption at rest and in transit
- Immutable and reviewed infrastructure changes
- Automated formatting, validation, and security scanning
- Explicit logging, monitoring, and drift detection

## Cost principles

- Deploy only one environment
- Use a minimal WAF ruleset
- Avoid paid WAF add-ons
- Use one KMS key initially
- Apply short log-retention policies
- Create budget alerts before application resources
- Destroy chargeable resources after project review

