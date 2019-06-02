output "s3logging_bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.s3logging_bucket.arn
}

output "s3logging_bucket_name" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.s3logging_bucket.bucket
}

