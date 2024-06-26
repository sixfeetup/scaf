resource "aws_s3_bucket_policy" "static_storage" {
  bucket = data.aws_s3_bucket.static_storage.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Sid": "AllowCloudFrontServicePrincipalReadOnly",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudfront.amazonaws.com"
        },
        "Action": "s3:GetObject",
        "Resource": "${data.aws_s3_bucket.static_storage.arn}/*",
        "Condition": {
            "StringEquals": {
                 "AWS:SourceArn": "${aws_cloudfront_distribution.ec2_cluster.arn}"
            }
        }
    }
}
EOF
}
