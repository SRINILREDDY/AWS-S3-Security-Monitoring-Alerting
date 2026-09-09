# AWS S3 Security Monitoring & Alerting

## Overview

Built an event-driven AWS security monitoring solution to detect changes to Amazon S3 Public Access Block configuration and send security alerts through email.

The infrastructure is provisioned using Terraform and integrates AWS CloudTrail, Amazon EventBridge, Amazon SNS, and Amazon CloudWatch.

## Architecture

S3 → CloudTrail → EventBridge → SNS → Email

## AWS Services

- Amazon S3
- AWS CloudTrail
- Amazon EventBridge
- Amazon SNS
- Amazon CloudWatch
- Terraform

## How It Works

1. An S3 Public Access Block configuration is modified.
2. AWS CloudTrail captures the API activity.
3. Amazon EventBridge detects the `PutBucketPublicAccessBlock` event.
4. EventBridge sends the matching event to an Amazon SNS topic.
5. Amazon SNS delivers the security notification to the subscribed email address.
6. Amazon CloudWatch is used for monitoring and reviewing AWS activity and logs.

## Terraform Resources

The project provisions:

- S3 bucket
- S3 bucket versioning
- S3 Block Public Access configuration
- S3 bucket policy for CloudTrail
- CloudTrail trail
- EventBridge security rule
- EventBridge SNS target
- SNS topic
- SNS email subscription
- SNS topic policy

## Security Monitoring

The EventBridge rule monitors the following CloudTrail API event:

```text
PutBucketPublicAccessBlock