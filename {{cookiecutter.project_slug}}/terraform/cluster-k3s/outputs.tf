output "instance_ip" {
  value = aws_eip.k8s-ip.public_ip
}

output "ami_id" {
  description = "AMI id to use in the EC2 instance, warning - will update when AMI updates"
  value       = data.aws_ami.latest_ubuntu.id
}