output "subnetId" {
  description = "Subnet ID's"
  value       = aws_subnet.subnet[*]
}

output "igwID" {
  description = "Internet gateway ID"
  value       = aws_internet_gateway.gw.id
}

output "vpcID" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}