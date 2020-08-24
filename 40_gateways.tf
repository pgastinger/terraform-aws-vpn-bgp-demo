resource "aws_ec2_transit_gateway" "tgw" {
  tags = {
    Name = "TGW"
  }
}

resource "aws_customer_gateway" "router1" {
  bgp_asn    = 65016
  ip_address = aws_instance.router[0].public_ip
  type       = "ipsec.1"

  tags = {
    Name = "ONPREM-ROUTER1"
  }
}

resource "aws_customer_gateway" "router2" {
  bgp_asn    = 65016
  ip_address = aws_instance.router[1].public_ip
  type       = "ipsec.1"

  tags = {
    Name = "ONPREM-ROUTER2"
  }
}


resource "aws_vpn_connection" "A4LTGW_R1" {
  customer_gateway_id = aws_customer_gateway.router1.id
  transit_gateway_id  = aws_ec2_transit_gateway.tgw.id
  type                = aws_customer_gateway.router1.type

  tags = {
    Name = "ONPREM-ROUTER1-VPN"
  }
}

resource "aws_vpn_connection" "A4LTGW_R2" {
  customer_gateway_id = aws_customer_gateway.router2.id
  transit_gateway_id  = aws_ec2_transit_gateway.tgw.id
  type                = aws_customer_gateway.router2.type

  tags = {
    Name = "ONPREM-ROUTER2-VPN"
  }
}
