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


resource "aws_route_table" "onprem-private-subnet-1-route-table" {
  vpc_id = aws_vpc.onprem.id

  route {
    cidr_block           = "10.16.0.0/16"
    network_interface_id = aws_network_interface.router1_lan.id
  }
  tags = {
    Name = "Route to VPN"
  }
}

resource "aws_route_table_association" "onprem-private-subnet-1-route-table-attach" {
  subnet_id      = aws_subnet.ONPREM-PRIVATE-1.id
  route_table_id = aws_route_table.onprem-private-subnet-1-route-table.id
}


resource "aws_route_table" "onprem-private-subnet-2-route-table" {
  vpc_id = aws_vpc.onprem.id

  route {
    cidr_block           = "10.16.0.0/16"
    network_interface_id = aws_network_interface.router2_lan.id
  }
  tags = {
    Name = "Route to VPN"
  }
}

resource "aws_route_table_association" "onprem-private-subnet-2-route-table-attach" {
  subnet_id      = aws_subnet.ONPREM-PRIVATE-2.id
  route_table_id = aws_route_table.onprem-private-subnet-2-route-table.id
}



resource "aws_route_table" "aws-rt" {
  vpc_id = aws_vpc.a4l_aws.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  tags = {
    Name = "A4L-AWS-RT"
  }
  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.tgw_attach,
    aws_ec2_transit_gateway.tgw

  ]
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
