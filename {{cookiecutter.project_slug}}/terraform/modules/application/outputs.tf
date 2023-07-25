output "application_user_access_key" {
  value = aws_iam_access_key.application_user_key.id
}

output "application_user_secret_key" {
  sensitive = true
  value     = aws_iam_access_key.application_user_key.secret
}

output "static_storage_bucket" {
  value = aws_s3_bucket.static_storage.bucket_domain_name
}