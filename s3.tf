provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "srinija-2958"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }

}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "cloudtrail" {

  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.bucket.arn]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.cloudtrail.json
}

resource "aws_s3_bucket_notification" "event_bridge" {
  bucket = aws_s3_bucket.bucket.id
  eventbridge = true
}