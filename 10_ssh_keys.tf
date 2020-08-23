resource "aws_key_pair" "my_pub_key" {
  key_name   = "my_pub_key"
  public_key = file("${path.module}/my_keys.pub")
}
