data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t2.micro"
  count         = 2
  key_name      = aws_key_pair.my_pub_key.key_name

  tags = {
    Name = "Router${count.index + 1}"
  }

}



resource "aws_key_pair" "my_pub_key" {
  key_name   = "my_pub_key"
  public_key = file("${path.module}/my_keys.pub")
  depends_on       = [time_sleep.wait_30_seconds]

}
