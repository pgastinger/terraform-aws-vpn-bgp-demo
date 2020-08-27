output "router1_public_ip" {
  value = aws_instance.router[0].public_ip
}
output "tunnel1_preshared_key" {
  value = aws_vpn_connection.A4LTGW_R1.tunnel1_preshared_key
}
output "tunnel2_preshared_key" {
  value = aws_vpn_connection.A4LTGW_R1.tunnel2_preshared_key
}
output "tunnel1_address" {
  value = aws_vpn_connection.A4LTGW_R1.tunnel1_address
}
output "tunnel2_address" {
  value = aws_vpn_connection.A4LTGW_R1.tunnel2_address
}

output "router2_public_ip" {
  value = aws_instance.router[1].public_ip
}
