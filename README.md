# Secure Static Hosting Pipeline

A security-first and cost-conscious static website hosting pipeline on AWS, built with Terraform and GitHub Actions.

The project started from a simple goal: host a static website securely using a private S3 bucket and CloudFront.

I deliberately took it further into a small **DevSecOps-style infrastructure project**, adding secure GitHub OIDC authentication, automated security scanning, immutable GitHub Actions references, Terraform testing, deployment previews, drift detection, monitoring and a documented teardown process.

The infrastructure is intentionally small and short-lived. Every component has a reason for being there, and unnecessary paid services were avoided.

## Technology Stack

### AWS & Infrastructure

![AWS](https://img.shields.io/badge/Cloud-AWS-FF9900?logo=amazonaws&logoColor=white)
![S3](https://img.shields.io/badge/Amazon-S3-569A31?logo=amazons3&logoColor=white)
![CloudFront](https://img.shields.io/badge/Amazon-CloudFront-FF9900?logo=amazonaws&logoColor=white)
![WAF](https://img.shields.io/badge/AWS-WAF-DD344C?logo=amazonaws&logoColor=white)
![KMS](https://img.shields.io/badge/AWS-KMS-DD344C?logo=amazonaws&logoColor=white)
![Route53](https://img.shields.io/badge/Amazon-Route_53-8C4FFF?logo=amazonaws&logoColor=white)
![ACM](https://img.shields.io/badge/AWS-ACM-DD344C?logo=amazonaws&logoColor=white)
![CloudWatch](https://img.shields.io/badge/Amazon-CloudWatch-FF4F8B?logo=amazonaws&logoColor=white)
![SNS](https://img.shields.io/badge/Amazon-SNS-FF4F8B?logo=amazonaws&logoColor=white)
![IAM](https://img.shields.io/badge/AWS-IAM-DD344C?logo=amazonaws&logoColor=white)

### Infrastructure as Code

![Terraform](https://img.shields.io/badge/IaC-Terraform-844FBA?logo=terraform&logoColor=white)
![TFLint](https://img.shields.io/badge/Terraform-TFLint-844FBA?logo=terraform&logoColor=white)

### CI/CD & Security

![GitHub Actions](https://img.shields.io/badge/CI/CD-GitHub_Actions-2088FF?logo=githubactions&logoColor=white)
![OIDC](https://img.shields.io/badge/Auth-OIDC-EB5424?logo=openid&logoColor=white)
![Semgrep](https://img.shields.io/badge/SAST-Semgrep-23C55E)
![Checkov](https://img.shields.io/badge/IaC_Security-Checkov-4B5563)
![Gitleaks](https://img.shields.io/badge/Secrets-Gitleaks-111827)
![Grype](https://img.shields.io/badge/Vulnerabilities-Grype-4C1D95)
![Dependabot](https://img.shields.io/badge/Dependencies-Dependabot-0366D6?logo=dependabot&logoColor=white)

### Development

![Git](https://img.shields.io/badge/Version_Control-Git-F05032?logo=git&logoColor=white)
![YAML](https://img.shields.io/badge/Config-YAML-CB171E?logo=yaml&logoColor=white)
![pnpm](https://img.shields.io/badge/Package_Manager-pnpm-F69220?logo=pnpm&logoColor=white)

## What This Project Does

The finished solution provides:

- a private S3 bucket for static website content;
- CloudFront distribution using Origin Access Control;
- HTTPS through ACM and Route 53;
- AWS WAF managed rules at the CloudFront edge;
- KMS encryption for site content and the dedicated log bucket;
- security response headers;
- GitHub Actions authentication through AWS OIDC;
- automated formatting, validation and security checks;
- Terraform plan previews for pull requests;
- scheduled Terraform drift detection;
- IaC, SAST, secret and vulnerability scanning;
- CloudWatch monitoring with SNS email alerts;
- native Terraform configuration tests;
- short-lived, cost-conscious infrastructure with documented teardown.

## Project Goals

The original project requirements were deliberately kept as the baseline rather than the ceiling.

The core goals were:

- Host static content in a private S3 bucket.
- Serve it through CloudFront using OAC.
- Protect the distribution with AWS WAF.
- Encrypt content using AWS KMS.
- Deploy through Terraform.
- Build a secure GitHub Actions pipeline.
- Run automated security checks before deployment.
- Provide a custom HTTPS domain.
- Keep infrastructure inexpensive and easy to destroy.

The project was then extended with additional controls where they provided a clear engineering benefit rather than simply adding more services.

---

# 1. Repository Structure

The repository separates the static site, Terraform infrastructure and GitHub Actions configuration.

```text
secure-static-hosting-pipeline/
│
├── .github/
│   ├── dependabot.yml
│   └── workflows/
│       ├── build.yml
│       ├── deploy.yml
│       ├── drift.yml
│       ├── plan.yml
│       └── security.yml
│
├── .githooks/
│   └── pre-commit
│
├── .vscode/
│   └── settings.json
│
├── infra/
│   ├── bootstrap/
│   ├── modules/
│   │   ├── acm/
│   │   ├── cloudfront/
│   │   ├── iam/
│   │   ├── kms/
│   │   ├── monitoring/
│   │   ├── route53/
│   │   └── s3/
│   ├── tests/
│   │   └── security.tftest.hcl
│   ├── backend.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   └── variables.tf
│
├── scripts/
│   └── check-site-integrity.sh
│
├── site/
│   └── index.html
│
├── .gitignore
├── .tflint.hcl
├── .yamllint.yml
├── package.json
├── pnpm-lock.yaml
└── README.md
```

The structure keeps deployment logic, infrastructure, testing and local tooling separated while remaining small enough to understand quickly.

## Architecture

> The architecture diagram will be added separately once the implementation is complete.

The request path is:

```text
User
  |
  v
Route 53
  |
  v
CloudFront
  |
  +--> AWS WAF
  |
  +--> Security response headers
  |
  v
S3 private site bucket
  |
  +--> KMS encryption
```

Infrastructure and delivery are managed separately:

```text
Developer
   |
   v
GitHub
   |
   +--> Build
   +--> Security
   +--> Terraform Plan
   +--> Deploy
   +--> Drift Detection
```

AWS authentication is handled through GitHub OIDC rather than long-lived credentials.

---

## Live Site

🌐 **[Visit the hardened static site](https://labs.alexandravladu.co.uk)**

The final deployment is served over the custom HTTPS domain:

```text
https://labs.alexandravladu.co.uk
```

The endpoint was verified successfully with an HTTP `200` response and the expected security headers.

---

# 2. Project Kickoff

The initial goal was intentionally small:

> Build a secure static website using S3 and CloudFront.

Rather than stopping once the website worked, I used the project as an opportunity to build a more complete infrastructure and DevSecOps workflow around it.

The implementation followed the same basic process throughout:

> **Plan → review → apply → verify**

Terraform changes were reviewed before applying them, and AWS resources were manually verified after infrastructure changes.

This became particularly important as the project grew, because several AWS and CI/CD behaviours were not obvious from the initial configuration.

---

# 3. Architecture and Design Decisions

The architecture was driven by four principles:

- **security**
- **cost**
- **simplicity**
- **maintainability**

I intentionally avoided adding services simply because they are common in production architectures.

The result is a deliberately small architecture:

- S3
- CloudFront
- WAF
- KMS
- ACM
- Route 53
- IAM
- CloudWatch
- SNS
- GitHub Actions

There is no EC2, ECS, ALB, NAT Gateway, database or container runtime because a static website does not require them.

## Private S3 + CloudFront OAC

The S3 site bucket is not publicly accessible.

CloudFront retrieves objects through **Origin Access Control**, allowing the bucket policy to grant access specifically to the CloudFront distribution rather than the public internet.

The intended request flow is therefore:

```text
Browser
   |
   v
CloudFront
   |
   v
S3
```

rather than:

```text
Browser
   |
   v
Public S3 bucket
```

## HTTPS

The site uses:

- ACM for the TLS certificate;
- Route 53 for DNS;
- CloudFront for HTTPS termination;
- HTTP-to-HTTPS redirection.

The configuration was also verified using the live endpoint rather than relying only on Terraform configuration.

## Security Headers

CloudFront uses a managed response headers policy to provide security headers including:

- `Strict-Transport-Security`
- `X-Content-Type-Options`
- `X-Frame-Options`
- `Referrer-Policy`

A custom response headers policy was initially attempted, but the CloudFront Free pricing plan rejected custom response-header policies. The configuration was therefore changed to use the supported managed policy.

---

# 4. AWS WAF

The CloudFront distribution uses the **WAF Web ACL provided through the CloudFront pricing plan**.

The Web ACL contains three AWS managed rule groups:

```text
AWS Managed IP Reputation List
AWS Managed Common Rule Set
AWS Managed Known Bad Inputs Rule Set
```

Initially, the managed rule groups were configured with `Count` overrides.

That meant the rules were observing matches without enforcing their normal terminating actions.

I changed all three rule groups to:

```text
Override action: None
```

so the managed rule groups could enforce their normal actions.

The final WAF configuration was verified directly through the AWS API rather than assuming the Terraform configuration represented the complete WAF state.

## Why WAF is not Terraform-managed

The Web ACL is created and managed as part of the CloudFront pricing-plan integration rather than as an independently created `aws_wafv2_web_acl` resource.

Creating a second Terraform-managed Web ACL would introduce unnecessary ownership complexity and could conflict with the pricing-plan-managed configuration.

The project's Terraform configuration therefore leaves the Web ACL association outside Terraform ownership while documenting the operational configuration.

---

# 5. Cost-Conscious Design

Cost was a major design constraint from the beginning.

This project is intended to be **short-lived**, so the architecture deliberately avoids services with unnecessary continuous costs.

Key decisions included:

- one environment only;
- CloudFront Free pricing plan;
- minimal WAF rule set;
- one customer-managed KMS key for site/log content;
- short log retention;
- no NAT Gateway;
- no load balancer;
- no compute fleet;
- no duplicate environments;
- manual teardown after the project review.

The goal was not to build the largest possible AWS architecture. The goal was to build the strongest architecture that made sense for a small static site while keeping recurring cost under control.

## CloudFront logging limitation

A dedicated S3 log bucket exists and is KMS-encrypted, but CloudFront access logging is not enabled because the CloudFront Free pricing plan does not provide that logging capability.

Rather than upgrading the distribution solely to satisfy a scanner, this limitation is treated as an explicit design trade-off and documented in the project.

---

# 6. Infrastructure as Code with Terraform

The infrastructure is managed with **Terraform**, split into logical modules:

```text
infra/
├── modules/
│   ├── acm/
│   ├── cloudfront/
│   ├── iam/
│   ├── kms/
│   ├── monitoring/
│   ├── route53/
│   └── s3/
├── bootstrap/
└── main.tf
```

The modular structure keeps related infrastructure together without creating a separate module for every individual AWS resource.

## Terraform state

Terraform state is stored remotely in Amazon S3 with encryption, versioning and native S3 state locking.

The state backend uses the S3 locking mechanism:

```hcl
use_lockfile = true
```

A dedicated read-only Terraform plan role is used by automated plan and drift workflows so those workflows do not inherit the permissions required by the deployment role.

## Terraform workflow

Infrastructure changes follow:

> **`fmt` → `validate` → `plan` → review → `apply` → verify**

Native `terraform test` is also used for plan-time configuration assertions.

---

# 7. CI/CD with GitHub Actions

The project uses GitHub Actions for separate build, security, deployment, Terraform plan and drift workflows.

## Secure AWS authentication with OIDC

GitHub Actions authenticates to AWS using **OIDC**, so no long-lived AWS access keys are stored in GitHub.

The existing GitHub OIDC provider in the AWS account is reused rather than attempting to create a duplicate provider.

The deployment role is restricted to the specific repository and main branch, while the read-only Terraform plan role additionally permits the pull-request OIDC subject required by `plan.yml`.

## Immutable GitHub Actions references

Semgrep identified mutable GitHub Actions references during development.

Workflow actions such as `actions/checkout`, Terraform setup, TFLint, Gitleaks and Grype were therefore pinned to immutable commit SHAs while retaining the human-readable version as an inline comment.

Dependabot is configured with a seven-day cooldown for GitHub Actions updates.

This adds supply-chain protection while still allowing dependency updates to be maintained automatically.

## Build validation

The Build workflow performs:

```text
Formatting
   ↓
Terraform formatting check
   ↓
YAML linting
   ↓
Site integrity check
   ↓
Terraform validation
   ↓
TFLint
```

## Security pipeline

The Security workflow performs several independent security checks:

```text
Checkov
   ↓
Semgrep SAST
   ↓
Gitleaks
   ↓
Grype
```

This provides IaC scanning, static analysis, secret detection and vulnerability scanning without introducing a container build requirement.

## Terraform plan preview

`plan.yml` runs for pull requests affecting the infrastructure and uses the dedicated read-only Terraform role.

The plan workflow can access the real remote state but has no deployment permissions.

This provides a reviewable preview before infrastructure changes are merged.

## Terraform drift detection

`drift.yml` performs a scheduled:

```bash
terraform plan -refresh-only -detailed-exitcode
```

The workflow uses the read-only Terraform role and does not apply changes.

The exit codes are interpreted as:

```text
0 = no drift
1 = error
2 = drift detected
```

A manual `workflow_dispatch` trigger is also provided for an on-demand drift check.

---

# 8. Local Development and Pre-Commit Checks

The repository includes a `.githooks/pre-commit` hook so local checks happen automatically when committing.

The hook runs the project's linting and validation scripts rather than relying on the developer to remember to run them manually.

The repository uses pnpm scripts for formatting and linting, including Terraform and YAML checks.

When a linting problem is found, the hook prints the actual error and suggests:

```bash
pnpm lint:fix
```

This keeps the normal workflow as:

```text
edit
  ↓
git commit
  ↓
automated checks
  ↓
fix reported issues
  ↓
commit
```

The `.yamllint.yml` configuration is kept at the repository root and applies to YAML checks under `.github`.

---

# 9. Troubleshooting and Lessons Learned

A significant part of this project was dealing with real AWS and GitHub Actions behaviour rather than simply following a happy-path tutorial.

## CloudFront pricing-plan constraints

An attempt to remove the existing CloudFront WAF association failed because distributions using the pricing plan must retain a Web ACL.

A later attempt to attach a custom response headers policy also failed because custom response header policies are not supported by the Free plan.

The final implementation uses the pricing-plan-managed WAF and the supported managed CloudFront security headers policy.

## Existing GitHub OIDC provider

Terraform initially attempted to create a GitHub OIDC provider that already existed in the AWS account.

AWS returned:

```text
EntityAlreadyExists: Provider with url https://token.actions.githubusercontent.com already exists.
```

The configuration was changed to use the existing provider as a data source instead of trying to create another one.

## Temporary AWS credentials in new terminals

Terraform plans initially failed in newly opened terminals because the AWS profile environment variable was not set.

The local workflow was standardized around:

```bash
export AWS_PROFILE=secure-static-site
export TF_VAR_sns_email="your-email@example.com"
```

The email value is deliberately kept outside the repository.

## Terraform state lock

One Terraform plan encountered an S3 state-lock acquisition error caused by a stale lock from a previous process.

The lock ID was inspected before using:

```bash
terraform force-unlock <LOCK_ID>
```

Locking was not disabled with `-lock=false`.

## Plan role permissions

The first version of the read-only Terraform plan role did not include all of the AWS read operations Terraform performs while refreshing the state.

The PR plan therefore produced misleading partial results, including claims that existing S3 buckets had been deleted.

The buckets were verified directly through the AWS API and found to still exist.

Additional read permissions were then added for ACM tags, CloudFront origin access controls and policy lists, KMS resource tags and SNS tags.

This demonstrated why a Terraform plan role needs to cover not only obvious resource reads but also the discovery and metadata APIs used by the provider.

## Semgrep and GitHub Actions

Semgrep initially blocked the security pipeline because GitHub Actions were referenced using mutable tags such as `@v7`, `@v6` and `@v4`.

The first failures were also awkward to diagnose because the GitHub Actions UI did not expose the useful step-level output consistently.

The GitHub CLI was installed locally and used to inspect the failed run:

```bash
gh run view <RUN_ID> --log-failed
```

That exposed the actual Semgrep findings.

The action tags were then resolved to immutable commit SHAs using `git ls-remote`, and the workflows were updated accordingly.

## Dependabot cooldown

Adding Dependabot caused Semgrep to identify another security configuration issue: the Dependabot configuration did not specify a cooldown period.

A seven-day cooldown was added for GitHub Actions updates so newly released versions are not proposed immediately.

## WAF rule overrides

The pricing-plan-managed WAF initially had its AWS managed rule groups configured with `Count` overrides.

The configuration was changed so all three managed rule groups use `None` for the override action, allowing their normal actions to take effect.

The final state was verified directly through the WAF API.

## Security scanner exceptions

Some Checkov findings represented real limitations or deliberate project trade-offs rather than configuration mistakes.

Examples include:

- CloudFront access logging unavailable on the selected pricing plan;
- the CloudFront-managed WAF being outside Terraform ownership;
- read-only discovery permissions requiring wildcard resource scope for some AWS APIs;
- deliberately omitted replication or notification features for this short-lived project.

Where appropriate, these were handled with narrow resource-level Checkov suppressions containing an explicit justification rather than globally disabling security rules.

---

# 10. Monitoring and Alerting

Operational monitoring uses CloudWatch and SNS.

The current alerting path is:

```text
CloudFront metric
      ↓
CloudWatch alarm
      ↓
SNS
      ↓
Email
```

The monitored CloudFront failure metric is the `5xxErrorRate` alarm.

The email address is supplied through environment configuration or the GitHub repository secret rather than stored in Git.

The monitoring configuration is intentionally small to avoid alert noise and unnecessary operational complexity.

---

# 11. Getting Started

## Prerequisites

You will need:

- Git
- Terraform
- AWS CLI
- pnpm
- an AWS account with the required permissions
- GitHub access for the repository and Actions configuration

VS Code is recommended but not required.

## Clone the repository

```bash
git clone https://github.com/Alexandrav21/secure-static-hosting-pipeline.git
cd secure-static-hosting-pipeline
```

## Configure local Git hooks

```bash
git config core.hooksPath .githooks
```

The pre-commit hook will then run automatically when committing changes.

## Configure local AWS access

Use an existing AWS CLI profile rather than storing credentials in the repository:

```bash
export AWS_PROFILE=secure-static-site
export TF_VAR_sns_email="your-email@example.com"
```

## Run local checks

```bash
pnpm install
pnpm lint
```

Run the site integrity test directly with:

```bash
./scripts/check-site-integrity.sh
```

Run Terraform validation from `infra/`:

```bash
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
```

Native Terraform tests can be run with:

```bash
terraform test
```

---

# 12. Deployment Workflow

Infrastructure changes follow:

```text
Create branch
    ↓
Make changes
    ↓
Pre-commit checks
    ↓
Open pull request
    ↓
Build + Security + Terraform Plan
    ↓
Review
    ↓
Merge to main
    ↓
Deploy
    ↓
HTTPS verification
```

The deployment workflow authenticates to AWS through GitHub OIDC and uses the deployment role only after code has passed the required checks.

The Terraform plan workflow is intentionally separate from deployment so infrastructure can be reviewed before it is applied.

---

# 13. Cleanup and Teardown

This project is intentionally short-lived. When the review period is finished, chargeable resources should be removed rather than left running indefinitely.

The primary Terraform teardown is manual:

```bash
cd infra
terraform destroy
```

The bootstrap/state resources are handled separately because the Terraform backend must remain available while the main infrastructure is being destroyed.

---

# 15. Future Improvements

If this project were extended beyond its short-lived portfolio scope, possible next steps would include:

- enabling CloudFront access logging by moving to a pricing tier that supports it;
- introducing additional CloudWatch alarms based on actual operational needs;
- adding stricter branch protection and required status checks;
- introducing separate environments if the project grew beyond a single deployment;
- adding a larger suite of infrastructure tests if the Terraform module surface expanded;
- reviewing and further tightening the permissions of the human-operated Terraform role used locally.

For the current project, additional complexity is deliberately avoided in favour of a small, understandable and secure architecture.
