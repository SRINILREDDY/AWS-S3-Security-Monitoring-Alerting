# AWS S3 Security Monitoring & Alerting Pipeline

Event-driven security monitoring for S3 using AWS CloudTrail, Amazon EventBridge, Amazon SNS, and Amazon CloudWatch — fully provisioned with Terraform.

---

## Overview

This project implements an automated alerting pipeline that detects S3 security-relevant API events (e.g., `PutBucketPublicAccessBlock`) in real time. When a matching event is captured by CloudTrail, EventBridge routes it to an SNS topic which delivers an email notification. CloudWatch logs the event for audit and verification.

---

## Architecture

```
S3 Bucket
    │
    │  API Event (e.g., PutBucketPublicAccessBlock)
    ▼
AWS CloudTrail  ──►  Amazon EventBridge  ──►  Amazon SNS  ──►  Email Alert
                              │
                              ▼
                     Amazon CloudWatch (Logs)
```

---

## Tech Stack

| Service | Role |
|---|---|
| **AWS S3** | Source bucket being monitored |
| **AWS CloudTrail** | Captures API activity across the account |
| **Amazon EventBridge** | Rule-based event routing on CloudTrail events |
| **Amazon SNS** | Delivers email alerts to subscribers |
| **Amazon CloudWatch** | Logs and validates triggered events |
| **Terraform** | Infrastructure as Code — provisions all resources |

---

## How It Works

1. **CloudTrail** is enabled and logging S3 data-plane and management events.
2. An **EventBridge rule** filters for `PutBucketPublicAccessBlock` API calls sourced from CloudTrail.
3. Matching events are routed to an **SNS topic**.
4. SNS delivers an **email notification** to the configured subscriber.
5. A **CloudWatch log group** captures the event for audit trail and verification.

---

## Project Structure

```
.
├── main.tf           # Provider configuration
├── cloudtrail.tf     # CloudTrail trail and S3 log bucket
├── eventbridge.tf    # EventBridge rule and SNS target
├── sns.tf            # SNS topic and email subscription
├── cloudwatch.tf     # CloudWatch log group
├── variables.tf      # Input variables
├── outputs.tf        # Output values (SNS ARN, trail ARN, etc.)
└── terraform.tfvars  # Variable values (not committed)
```

---

## Prerequisites

- AWS account with appropriate IAM permissions
- Terraform ≥ 1.3
- AWS CLI configured (`aws configure`)

---

## Deploy

```bash
git clone https://github.com/<your-username>/aws-s3-security-monitoring-terraform.git
cd aws-s3-security-monitoring-terraform

terraform init
terraform plan
terraform apply
```

After `apply`, confirm the SNS email subscription from your inbox before testing.

---

## Test

Trigger the monitored event manually:

```bash
aws s3api put-public-access-block \
  --bucket <your-bucket-name> \
  --public-access-block-configuration \
    "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

Expected outcome:
- Email notification received via SNS
- Event visible in CloudWatch Logs

---

## Verify in CloudWatch

```bash
aws logs describe-log-groups --log-group-name-prefix "/aws/events/"
aws logs filter-log-events --log-group-name "<your-log-group>"
```

---

## Cleanup

```bash
terraform destroy
```

> Note: Unsubscribe from the SNS topic before destroying if the email subscription is still pending.

---

## Key Concepts Demonstrated

- Event-driven architecture on AWS
- CloudTrail → EventBridge integration for API-level security monitoring
- Infrastructure as Code with Terraform
- SNS-based alerting pipeline
- CloudWatch logging for security audit trails
