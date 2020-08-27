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
output "tunnel1_cgw_inside_address" {
  value = join("",[aws_vpn_connection.A4LTGW_R1.tunnel1_cgw_inside_address,"/30"])
}
output "tunnel1_vgw_inside_address" {
  value = join("",[aws_vpn_connection.A4LTGW_R1.tunnel1_vgw_inside_address,"/30"])
}
output "tunnel2_address" {
  value = aws_vpn_connection.A4LTGW_R1.tunnel2_address
}

output "tunnel2_cgw_inside_address" {
  value = join("",[aws_vpn_connection.A4LTGW_R1.tunnel2_cgw_inside_address,"/30"])
}
output "tunnel2_vgw_inside_address" {
  value = join("",[aws_vpn_connection.A4LTGW_R1.tunnel2_vgw_inside_address,"/30"])
}
output "router2_public_ip" {
  value = aws_instance.router[1].public_ip
}
