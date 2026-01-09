output "recorder_id" {
  description = "Config recorder ID"
  value       = aws_config_configuration_recorder.main.id
}

output "s3_bucket_name" {
  description = "S3 bucket name for Config logs"
  value       = aws_s3_bucket.config.id
}
