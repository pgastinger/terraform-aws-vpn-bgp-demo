data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_ami" "router_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "router" {
  ami                    = data.aws_ami.router_ami.id
  instance_type          = "t2.micro"
  count                  = 2
  key_name               = aws_key_pair.my_pub_key.key_name
  subnet_id              = aws_subnet.ONPREM-PUBLIC.id
  vpc_security_group_ids = [aws_security_group.onprem-sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  source_dest_check      = false
  tags = {
    Name = "ONPREM-ROUTER${count.index + 1}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update && sudo apt install -y strongswan wget frr",
      "sudo sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons",
      "sudo service frr restart",
      "mkdir /home/ubuntu/demo_assets",
      "cd /home/ubuntu/demo_assets",
      "wget https://raw.githubusercontent.com/pgastinger/terraform-aws-vpn-bgp-demo/master/ressources/51-eth1.yaml",
      "sudo chown ubuntu:ubuntu /home/ubuntu/demo_assets -R",
      "sudo cp /home/ubuntu/demo_assets/51-eth1.yaml /etc/netplan",
      "sudo netplan --debug apply"
    ]
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("${path.module}/my_keys")
    }
  }

}

resource "aws_network_interface" "router1_lan" {
  subnet_id         = aws_subnet.ONPREM-PRIVATE-1.id
  security_groups   = [aws_security_group.onprem-sg.id]
  source_dest_check = false

  attachment {
    instance     = aws_instance.router[0].id
    device_index = 1
  }
}

resource "aws_network_interface" "router2_lan" {
  subnet_id         = aws_subnet.ONPREM-PRIVATE-2.id
  security_groups   = [aws_security_group.onprem-sg.id]
  source_dest_check = false

  attachment {
    instance     = aws_instance.router[1].id
    device_index = 1
  }
}


resource "aws_instance" "server1" {
  ami                         = data.aws_ami.app_ami.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.my_pub_key.key_name
  subnet_id                   = aws_subnet.ONPREM-PRIVATE-1.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.onprem-sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
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
  vpc_security_group_ids      = [aws_security_group.onprem-sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
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
  vpc_security_group_ids      = [aws_security_group.aws-sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
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
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids      = [aws_security_group.aws-sg.id]
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
