
resource "aws_instance" "ec2" {
  ami           = var.amiID
  instance_type = var.instanceType
  key_name      = var.ec2KeyName

  network_interface {
    network_interface_id = aws_network_interface.eni.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
  tags = {
    Name = var.instanceName
  }
}

resource "aws_network_interface" "eni" {
  subnet_id       = var.instanceSubnetID
  security_groups = var.sgList
  tags = {
    Name = "${var.instanceName}-eni"
  }
}

resource "aws_eip" "lb" {
  for_each = var.enablePublicIP ? { "eip" = aws_instance.ec2.id } : {}
  instance = each.value
  domain   = "vpc"
}

resource "aws_eip_association" "eip_assoc" {
  for_each      = var.enablePublicIP ? aws_eip.lb : {}
  instance_id   = aws_instance.ec2.id
  allocation_id = aws_eip.lb[each.key].id
}
