resource "aws_vpc" "a4l_aws" {
  cidr_block = "10.16.0.0/16"

  tags = {
    Name = "A4L-AWS"
  }
}

resource "aws_vpc" "onprem" {
  cidr_block = "192.168.8.0/21"

  tags = {
    Name = "ONPREM"
  }
}


resource "aws_internet_gateway" "igw_aws" {
  vpc_id = aws_vpc.a4l_aws.id

  tags = {
    Name = "IGW-AWS"
  }
}

resource "aws_internet_gateway" "igw_onprem" {
  vpc_id = aws_vpc.onprem.id

  tags = {
    Name = "IGW-ONPREM"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "ONPREM-PRIVATE-1" {
  vpc_id                  = aws_vpc.onprem.id
  cidr_block              = "192.168.10.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "ONPREM-PRIVATE-1"
  }
}

resource "aws_subnet" "ONPREM-PRIVATE-2" {
  vpc_id                  = aws_vpc.onprem.id
  cidr_block              = "192.168.11.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "ONPREM-PRIVATE-2"
  }
}

resource "aws_subnet" "ONPREM-PUBLIC" {
  vpc_id                  = aws_vpc.onprem.id
  cidr_block              = "192.168.12.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "ONPREM-PUBLIC"
  }
}



resource "aws_subnet" "sn-aws-private-A" {
  vpc_id                  = aws_vpc.a4l_aws.id
  cidr_block              = "10.16.32.0/20"
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "sn-aws-private-A"
  }
}

resource "aws_subnet" "sn-aws-private-B" {
  vpc_id                  = aws_vpc.a4l_aws.id
  cidr_block              = "10.16.96.0/20"
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "sn-aws-private-B"
  }
}
