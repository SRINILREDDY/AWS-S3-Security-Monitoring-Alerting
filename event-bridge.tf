resource "aws_cloudwatch_event_rule" "s3_security" {
  name        = "s3-security-rule"
  description = "Detect S3 Public Access Block changes"

  event_pattern = jsonencode({
    source = [
      "aws.s3"
    ]

    detail-type = [
      "AWS API Call via CloudTrail"
    ]

     detail = {
      eventName = [
        "PutBucketPublicAccessBlock",
        "DeletePublicAccessBlock",
        "PutBucketPolicy",
        "DeleteBucketPolicy",
        "PutBucketAcl",
        "DeleteBucket",
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "sns" {
    rule = aws_cloudwatch_event_rule.s3_security.name
    arn = aws_sns_topic.alerts.arn
}

