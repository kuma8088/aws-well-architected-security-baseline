# AWS Well-Architected Security Baseline

AWS Well-Architected Framework (6 Pillars) compliant security baseline infrastructure built with Terraform.

## Overview

This project demonstrates the ability to build a security governance foundation for AWS environments, enabling security review and improvement recommendations for customer environments.

### Target Audience

- Information Systems Department
- Security Teams
- Compliance Officers

### Key Value Proposition

- **Direct proof** of "ability to review and propose security improvements for customer environments"
- Directly applicable to AWS consultant work (optimization advice)
- Demonstrates capability for Black Belt lecture delivery

## Architecture

```
Security Hub (Integrated Dashboard)
    |
    +-- GuardDuty ------> Threat Detection (unauthorized access, malware)
    |
    +-- Config ----------> Configuration Rule Violations (S3 public, no encryption, etc.)
    |
    +-- CloudTrail ------> API Audit Logs -> Anomaly Detection
    |
    +-- IAM Access Analyzer -> Excessive Permissions Detection
    |
    +-- Inspector -------> Vulnerability Scanning
            |
            v
    EventBridge -> SNS/Slack Notification
```

## Well-Architected 6 Pillars Alignment

| Pillar | Implementation in This Portfolio |
|:-------|:--------------------------------|
| Security | Security Hub, GuardDuty, Config, IAM Access Analyzer |
| Operational Excellence | CloudTrail, Automated Notifications |
| Reliability | Multi-AZ design assumption |
| Performance Efficiency | - |
| Cost Optimization | - |
| Sustainability | - |

## Technology Stack

| Service | Purpose |
|:--------|:--------|
| **Security Hub** | Security integrated dashboard |
| **GuardDuty** | Threat detection (unauthorized access, malware) |
| **AWS Config** | Configuration audit (S3 public exposure, encryption status) |
| **CloudTrail** | API audit logging |
| **IAM Access Analyzer** | Excessive permissions detection |
| **Inspector** | Vulnerability scanning |
| **EventBridge** | Event routing |
| **SNS** | Notification delivery |
| **Terraform** | Infrastructure as Code |

## Project Structure

```
.
├── environments/
│   ├── dev/           # Development environment
│   └── prod/          # Production environment
├── modules/
│   ├── security-hub/       # Security Hub configuration
│   ├── guardduty/          # GuardDuty setup
│   ├── config/             # AWS Config rules
│   ├── cloudtrail/         # CloudTrail configuration
│   ├── iam-analyzer/       # IAM Access Analyzer
│   ├── inspector/          # Inspector configuration
│   └── notification/       # EventBridge + SNS + Slack
├── docs/
│   └── plans/         # Design and implementation plans
└── README.md
```

## Security Findings Flow

```
1. Detection Layer
   +------------------+     +------------------+     +------------------+
   |    GuardDuty     |     |   AWS Config     |     |    Inspector     |
   | (Threat Detection)|     | (Compliance)     |     | (Vulnerability)  |
   +--------+---------+     +--------+---------+     +--------+---------+
            |                        |                        |
            v                        v                        v
2. Aggregation Layer
   +------------------------------------------------------------------+
   |                        Security Hub                               |
   |  - Unified security findings view                                |
   |  - Security score calculation                                    |
   |  - Compliance status tracking                                    |
   +--------------------------------+---------------------------------+
                                    |
                                    v
3. Notification Layer
   +------------------+     +------------------+     +------------------+
   |   EventBridge    | --> |       SNS        | --> |     Slack        |
   | (Event Routing)  |     | (Notification)   |     | (Alert Channel)  |
   +------------------+     +------------------+     +------------------+
```

## Severity Classification

| Severity | Channel | Response |
|:---------|:--------|:---------|
| CRITICAL | #alerts-security-critical | Immediate action required |
| HIGH | #alerts-security-high | Same-day response |
| MEDIUM | #alerts-security-warning | Within 1 week |
| LOW | #alerts-security-info | Periodic review |

## Getting Started

### Prerequisites

- AWS CLI configured
- Terraform >= 1.5.0
- Slack workspace (for notifications)

### Quick Start

```bash
# Clone repository
git clone https://github.com/kuma8088/aws-well-architected-security-baseline.git
cd aws-well-architected-security-baseline

# Configure environment
cd environments/dev
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# Deploy
terraform init
terraform plan
terraform apply
```

## Related Projects

- [AWS Observability Incident Response](https://github.com/kuma8088/aws-observability-incident-response) - Operational monitoring and incident response (PF14)

## License

MIT License

## Author

Naoya Iimura
