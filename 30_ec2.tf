data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "router" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t2.micro"
  count         = 2
  key_name      = aws_key_pair.my_pub_key.key_name
  subnet_id     = aws_subnet.ONPREM-PUBLIC.id

  tags = {
    Name = "ONPREM-ROUTER${count.index + 1}"
  }

}

resource "aws_instance" "server1" {
  ami                         = data.aws_ami.app_ami.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.my_pub_key.key_name
  subnet_id                   = aws_subnet.ONPREM-PRIVATE-1.id
  associate_public_ip_address = false
  tags = {
    Name = "ONPREM-SERVER1"
  }

}

resource "aws_instance" "server2" {
  ami                         = data.aws_ami.app_ami.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.my_pub_key.key_name
  subnet_id                   = aws_subnet.ONPREM-PRIVATE-2.id
  associate_public_ip_address = false
  tags = {
    Name = "ONPREM-SERVER2"
  }

}


resource "aws_instance" "aws_ec2_a" {
  ami                         = data.aws_ami.app_ami.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.my_pub_key.key_name
  subnet_id                   = aws_subnet.sn-aws-private-A.id
  associate_public_ip_address = false
  tags = {
    Name = "AWS-EC2-A"
  }

}

resource "aws_instance" "aws_ec2_b" {
  ami                         = data.aws_ami.app_ami.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.my_pub_key.key_name
  subnet_id                   = aws_subnet.sn-aws-private-B.id
  associate_public_ip_address = false
  tags = {
    Name = "AWS-EC2-B"
  }

}


resource "aws_eip" "router1_eip" {
  instance = aws_instance.router[0].id
  vpc      = true
}

resource "aws_eip" "router2_eip" {
  instance = aws_instance.router[1].id
  vpc      = true
}
