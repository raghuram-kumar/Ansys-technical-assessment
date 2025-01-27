resource "aws_security_group" "sg" {
  name        = var.sgName
  description = var.sgDescription
  vpc_id      = var.sgVPCID
  tags        = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "sg_rule_ingress" {
  count             = length(var.sgRulesIngress) > 0 ? length(var.sgRulesIngress) : 0
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = var.sgRulesIngress[count.index].cidr
  from_port         = var.sgRulesIngress[count.index].fromPort
  ip_protocol       = var.sgRulesIngress[count.index].protocol
  to_port           = var.sgRulesIngress[count.index].toPort
}

resource "aws_vpc_security_group_egress_rule" "sg_rule_egress" {
  count             = length(var.sgRulesEgress) > 0 ? length(var.sgRulesEgress) : 0
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = var.sgRulesEgress[count.index].cidr
  ip_protocol       = var.sgRulesEgress[count.index].protocol
}