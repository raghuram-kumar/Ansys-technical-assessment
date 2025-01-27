resource "aws_vpc" "vpc" {
  cidr_block = var.vpcCidr
  tags = {
    Name = var.vpcName
  }
}

resource "aws_subnet" "subnet" {
  for_each          = var.subnets != [] ? var.subnets : {}
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.subnetCIDR
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpcName}-igw"
  }
}