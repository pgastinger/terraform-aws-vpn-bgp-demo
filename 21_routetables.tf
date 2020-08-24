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
