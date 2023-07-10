output "domains" {
  value = [var.domain, var.api_domain]
}

output "ec2_cluster_public_dns" {
  value = data.aws_instance.ec2_cluster.public_dns
}

output "static_storage_domain" {
  value = aws_s3_bucket.static_storage.bucket_domain_name
}
