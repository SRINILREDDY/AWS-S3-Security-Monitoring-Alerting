resource "aws_cloudtrail" "security"{
    depends_on = [
         aws_s3_bucket_policy.cloudtrail]

    name = "srinil_cloudtrail"
    s3_bucket_name = aws_s3_bucket.bucket.id
    include_global_service_events = true
    enable_log_file_validation = true

}