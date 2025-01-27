output "natGwID" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.natgw[*]
}

output "rtbID" {
  description = "Route table ID"
  value       = aws_route_table.rtb[*]
}