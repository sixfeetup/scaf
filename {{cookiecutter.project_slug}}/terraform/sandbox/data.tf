data "aws_instance" "ec2_cluster" {
  instance_tags = { "Name" : "${module.global_variables.application}-ec2-cluster", "automation.config" : module.global_variables.application }
}