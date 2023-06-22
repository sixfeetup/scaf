resource "aws_key_pair" "default_key" {
  key_name   = "default_key"
  public_key = file(var.path_to_public_key)
}

resource "aws_eip" "k8s-ip" {
  instance = aws_instance.k8s.id
  domain   = "vpc"
}

resource "aws_instance" "k8s" {
  ami           = var.ami_id
  instance_type = var.instance_type

  root_block_device {
    volume_size = 30
  }

  associate_public_ip_address = true
  key_name                    = aws_key_pair.default_key.key_name

  vpc_security_group_ids = concat([aws_security_group.admin.id], [for o in aws_security_group.bitbucket : o.id])

  tags = merge(
    var.tags,
    {
      "Name" = "${module.global_variables.application}-ec2-cluster"
    },
  )
}
