# AWS S3 Security Monitoring & Alerting Pipeline

Event-driven security monitoring for Amazon S3 using AWS CloudTrail, Amazon EventBridge, Amazon SNS, and Terraform.

---

## Overview

This project implements an event-driven security monitoring and alerting pipeline for Amazon S3. AWS CloudTrail captures S3 API activity, Amazon EventBridge filters security-relevant API events, and Amazon SNS sends email notifications when a matching event occurs.

The EventBridge rule monitors multiple S3 security-related API events, including:

- `PutBucketPublicAccessBlock`
- `DeletePublicAccessBlock`
- `PutBucketPolicy`
- `DeleteBucketPolicy`
- `PutBucketAcl`
- `DeleteBucket`

> **Note:** `DeletePublicAccessBlock` is retained here to match the current Terraform configuration in `event-bridge.tf`.

---

## Architecture

```text
Amazon S3
    │
    │ S3 API activity
    ▼
AWS CloudTrail
    │
    │ AWS API Call via CloudTrail
    ▼
Amazon EventBridge
    │
    │ Security-related event matching
    ▼
Amazon SNS
    │
    ▼
Email Alert
```

---

## How It Works

1. **Amazon S3** is the resource being monitored.
2. **AWS CloudTrail** captures S3 API activity.
3. **Amazon EventBridge** evaluates CloudTrail events against a security-focused event pattern.
4. The rule matches multiple S3 API events related to public access, bucket policies, ACLs, and bucket deletion.
5. Matching events are sent to an **Amazon SNS topic**.
6. **Amazon SNS** delivers an email notification to the confirmed subscriber.

---

## Monitored Events

| S3 API Event | Security Relevance |
|---|---|
| `PutBucketPublicAccessBlock` | Detects changes to S3 public access block settings |
| `DeletePublicAccessBlock` | Detects removal of a public access block configuration |
| `PutBucketPolicy` | Detects bucket policy changes |
| `DeleteBucketPolicy` | Detects bucket policy removal |
| `PutBucketAcl` | Detects bucket ACL changes |
| `DeleteBucket` | Detects bucket deletion |

---

## Tech Stack

| Service / Tool | Role |
|---|---|
| **Amazon S3** | Bucket resource being monitored |
| **AWS CloudTrail** | Captures S3 API activity |
| **Amazon EventBridge** | Filters and routes matching CloudTrail events |
| **Amazon SNS** | Sends email security alerts |
| **Terraform** | Infrastructure as Code and resource provisioning |
| **AWS CloudWatch** | AWS monitoring and service visibility |

---

## Project Structure

```text
.
├── .gitignore
├── .terraform.lock.hcl
├── README.md
├── s3.tf             # S3 bucket and security configuration
├── cloudtrail.tf     # CloudTrail trail and logging configuration
├── event-bridge.tf   # EventBridge security rule and SNS target
└── sns.tf            # SNS topic, email subscription, and topic policy
```

---

## Prerequisites

- AWS account with appropriate IAM permissions
- Terraform installed
- AWS CLI installed and configured
- A confirmed SNS email subscription

---

## Deploy

Clone the repository:

```bash
git clone https://github.com/SRINILREDDY/AWS-S3-Security-Monitoring-Alerting.git
cd AWS-S3-Security-Monitoring-Alerting
```

Initialize and deploy the Terraform configuration:

```bash
terraform init
terraform plan
terraform apply
```

Confirm the SNS subscription from your email before testing alerts.

---

## Test the Alerting Pipeline

Trigger a monitored S3 API event. For example, change the bucket's Public Access Block configuration using the AWS CLI:

```bash
aws s3api put-public-access-block \
  --bucket <your-bucket-name> \
  --public-access-block-configuration \
    "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

Expected result:

- CloudTrail records the S3 API event.
- EventBridge matches the event.
- EventBridge publishes the event to the SNS topic.
- SNS sends an email notification to the subscribed email address.

You can repeat the test with other monitored S3 API operations where appropriate.

---

## Security Flow

```text
S3 API Activity
      ↓
CloudTrail Audit Event
      ↓
EventBridge Event Pattern
      ↓
SNS Topic
      ↓
Email Notification
```

This provides a decoupled, event-driven approach to detecting and alerting on important S3 configuration changes.

---

## Cleanup

To remove the Terraform-managed resources:

```bash
terraform destroy
```

If the SNS email subscription is still pending, confirm or unsubscribe it as appropriate before cleanup.

---

## Key Concepts Demonstrated

- AWS S3 security monitoring
- AWS CloudTrail API event auditing
- Amazon EventBridge event pattern matching
- Amazon SNS email alerting
- Event-driven architecture
- Infrastructure as Code with Terraform
- Security-focused cloud monitoring
- AWS service integration
