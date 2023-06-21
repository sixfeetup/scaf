output "instance_ip" {
  value = aws_eip.k8s-ip.public_ip
}
