resource "aws_route_table" "onprem-public-route-table" {
  vpc_id = aws_vpc.onprem.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_onprem.id
  }
  tags = {
    Name = "main"
  }
}

resource "aws_route_table_association" "onprem-public-subnet" {
  subnet_id      = aws_subnet.ONPREM-PUBLIC.id
  route_table_id = aws_route_table.onprem-public-route-table.id
}

resource "aws_route_table" "aws-rt" {
  vpc_id = aws_vpc.a4l_aws.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  tags = {
    Name = "A4L-AWS-RT"
  }
}

resource "aws_route_table_association" "aws-subnet-A" {
  subnet_id      = aws_subnet.sn-aws-private-A.id
  route_table_id = aws_route_table.aws-rt.id
}

resource "aws_route_table_association" "aws-subnet-B" {
  subnet_id      = aws_subnet.sn-aws-private-B.id
  route_table_id = aws_route_table.aws-rt.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach" {
  subnet_ids         = [aws_subnet.sn-aws-private-A.id, aws_subnet.sn-aws-private-B.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.a4l_aws.id
}
