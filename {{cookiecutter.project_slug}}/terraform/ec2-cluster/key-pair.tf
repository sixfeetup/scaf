resource "aws_key_pair" "default_key" {
  key_name   = "default_key"
  public_key = file(var.path_to_public_key)
}
