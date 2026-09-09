resource "aws_sns_topic" "alerts" {
  name = "s3-security-alerts"
}

resource "aws_sns_topic_subscription" "email" {
    topic_arn = aws_sns_topic.alerts.arn
    protocol = "email"
    endpoint = "srinilreddy539@gmail.com"
}

resource "aws_sns_topic_policy" "allow_eventbridge" {
  arn = aws_sns_topic.alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        

        Principal = {
          Service = "events.amazonaws.com"
        }

        Action = "sns:Publish"

        Resource = aws_sns_topic.alerts.arn
      }
    ]
  })
}