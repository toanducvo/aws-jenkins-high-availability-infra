resource "aws_vpc" "jenkins_vpc" {
  cidr_block           = var.jenkins_vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.jenkins_vpc_name
  }
}

resource "aws_subnet" "jenkins_public_subnets" {
  vpc_id                  = aws_vpc.jenkins_vpc.id
  for_each                = local.public_subnet_cidrs
  availability_zone       = each.value.availability_zone
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "jenkins-public-subnet-${each.value.availability_zone}"
  }
}

resource "aws_subnet" "jenkins_private_subnets" {
  vpc_id                  = aws_vpc.jenkins_vpc.id
  for_each                = local.private_subnet_cidrs
  availability_zone       = each.value.availability_zone
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = false
  tags = {
    Name = "jenkins-private-subnet-${each.value.availability_zone}"
  }
}

resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = {
    Name = "jenkins-igw"
  }
}

resource "aws_eip" "jenkins_eip" {
  for_each = local.public_subnet_cidrs
  domain   = "vpc"
}

resource "aws_nat_gateway" "jenkins_nat_gateway" {
  connectivity_type = "public"
  for_each          = local.public_subnet_cidrs
  subnet_id         = aws_subnet.jenkins_public_subnets[each.value.availability_zone].id
  allocation_id     = aws_eip.jenkins_eip[each.value.availability_zone].id

  tags = {
    Name = "jenkins-nat-gw-${each.value.availability_zone}"
  }
}

resource "aws_route_table" "jenkins_public_route_table" {
  vpc_id = aws_vpc.jenkins_vpc.id

  route {
    cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.jenkins_igw.id
  }

  tags = {
    Name = "jenkins-public-rt"
  }
}

resource "aws_route_table_association" "jenkins_public_route_table_association" {
  for_each       = local.public_subnet_cidrs
  route_table_id = aws_route_table.jenkins_public_route_table.id
  subnet_id      = aws_subnet.jenkins_public_subnets[each.value.availability_zone].id
}

resource "aws_route_table" "jenkins_private_route_table" {
  vpc_id   = aws_vpc.jenkins_vpc.id
  for_each = local.private_subnet_cidrs

  route {
    cidr_block     = var.cidr_block
    nat_gateway_id = aws_nat_gateway.jenkins_nat_gateway[each.value.availability_zone].id
  }

  tags = {
    Name = "jenkins-private-rt-${each.value.availability_zone}"
  }
}

resource "aws_route_table_association" "jenkins_private_route_table_association" {
  for_each       = local.private_subnet_cidrs
  route_table_id = aws_route_table.jenkins_private_route_table[each.value.availability_zone].id
  subnet_id      = aws_subnet.jenkins_private_subnets[each.value.availability_zone].id
}