resource "aws_eip" "ip" {
  for_each = tomap({ for i, ngw in var.natGateway : i => ngw })
  domain   = "vpc"
}

resource "aws_nat_gateway" "natgw" {
  for_each = aws_eip.ip

  allocation_id = aws_eip.ip[each.key].id
  subnet_id     = var.natGateway[tonumber(each.key)].subnetID

  tags = {
    Name = "${var.natGateway[tonumber(each.key)].natGatewayName}-natgw"
  }
  depends_on = [aws_eip.ip]
}

resource "aws_route_table" "rtb" {
  for_each = tomap({ for i, rtb in var.routeTable : i => rtb })

  vpc_id = var.vpcID

  dynamic "route" {
    for_each = each.value.routes == null ? [] : each.value.routes
    content {
      cidr_block             = route.value.cidrBlock
      gateway_id             = route.value.gatewayId
      nat_gateway_id         = route.value.natGatewayId
      egress_only_gateway_id = route.value.egressOnlyGatewayId
    }
  }

  tags = {
    Name = each.key
  }
}

resource "aws_route_table_association" "subnet_rtb_assoc" {
  for_each       = tomap({ for i, rtb in var.rtbAssociation : i => rtb })
  subnet_id      = each.value.subnetID
  route_table_id = each.value.routeTableID
}