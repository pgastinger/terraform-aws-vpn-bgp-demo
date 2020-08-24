resource "aws_security_group" "onprem-sg" {
  name        = "ONPREM-Instance-SG"
  description = "ONPREM-Instance-SG"
  vpc_id      = aws_vpc.onprem.id

  ingress {
    description = "Any from World"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ONPREM-Instance-SG"
  }
}

resource "aws_security_group" "aws-sg" {
  name        = "AWS-Instance-SG"
  description = "AWS-Instance-SG"
  vpc_id      = aws_vpc.a4l_aws.id

  ingress {
    description = "Any from World"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AWS-Instance-SG"
  }
}
