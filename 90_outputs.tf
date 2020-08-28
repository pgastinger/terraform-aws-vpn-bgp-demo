output "router1_public_ip" {
  value = aws_eip.router1_eip.public_ip
}
output "router1_private_ip" {
  value = aws_instance.router[0].private_ip
}
output "router2_public_ip" {
  value = aws_eip.router2_eip.public_ip
}
output "router2_private_ip" {
  value = aws_instance.router[1].private_ip
}
output "router1_tunnel1_preshared_key" {
  value = aws_vpn_connection.A4LTGW_R1.tunnel1_preshared_key
}
output "router1_tunnel2_preshared_key" {
  value = aws_vpn_connection.A4LTGW_R1.tunnel2_preshared_key
}
output "router1_tunnel1_address" {
  value = aws_vpn_connection.A4LTGW_R1.tunnel1_address
}
output "router1_tunnel1_cgw_inside_address" {
  value = join("", [aws_vpn_connection.A4LTGW_R1.tunnel1_cgw_inside_address, "/30"])
}
output "router1_tunnel1_vgw_inside_address" {
  value = join("", [aws_vpn_connection.A4LTGW_R1.tunnel1_vgw_inside_address, "/30"])
}
output "router1_tunnel2_address" {
  value = aws_vpn_connection.A4LTGW_R1.tunnel2_address
}
output "router1_tunnel2_cgw_inside_address" {
  value = join("", [aws_vpn_connection.A4LTGW_R1.tunnel2_cgw_inside_address, "/30"])
}
output "router1_tunnel2_vgw_inside_address" {
  value = join("", [aws_vpn_connection.A4LTGW_R1.tunnel2_vgw_inside_address, "/30"])
}
output "router2_tunnel1_preshared_key" {
  value = aws_vpn_connection.A4LTGW_R2.tunnel1_preshared_key
}
output "router2_tunnel2_preshared_key" {
  value = aws_vpn_connection.A4LTGW_R2.tunnel2_preshared_key
}
output "router2_tunnel1_address" {
  value = aws_vpn_connection.A4LTGW_R2.tunnel1_address
}
output "router2_tunnel1_cgw_inside_address" {
  value = join("", [aws_vpn_connection.A4LTGW_R2.tunnel1_cgw_inside_address, "/30"])
}
output "router2_tunnel1_vgw_inside_address" {
  value = join("", [aws_vpn_connection.A4LTGW_R2.tunnel1_vgw_inside_address, "/30"])
}
output "router2_tunnel2_address" {
  value = aws_vpn_connection.A4LTGW_R2.tunnel2_address
}
output "router2_tunnel2_cgw_inside_address" {
  value = join("", [aws_vpn_connection.A4LTGW_R2.tunnel2_cgw_inside_address, "/30"])
}
output "router2_tunnel2_vgw_inside_address" {
  value = join("", [aws_vpn_connection.A4LTGW_R2.tunnel2_vgw_inside_address, "/30"])
}
