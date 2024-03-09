resource "aws_vpc" "jenkins_vpc" {
  cidr_block = var.jenkins_vpc_cidr
  tags = {
    Name = var.jenkins_vpc_name
  }
}

resource "aws_subnet" "jenkins_public_subnets" {
  vpc_id                  = aws_vpc.jenkins_vpc.id
  for_each                = var.jenkins_public_subnet_cidrs
  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = "true"

  tags = {
    Name = var.jenkins_vpc_cidr
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.jenkins_vpc.id
  for_each          = var.jenkins_private_subnet_cidrs
  availability_zone = each.key
  cidr_block        = each.value

  tags = {
    Name = var.jenkins_public_subnet_cidrs
  }
}

resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = {
    Name = var.jenkins_igw_name
  }
}

resource "aws_route_table" "jenkins_route_table" {
  vpc_id   = aws_vpc.jenkins_vpc.id
  for_each = aws_subnet.jenkins_public_subnets

  route {
    cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.jenkins_igw.id
  }

  tags = {
    Name = "Jenkins-Public-Route-Table"
  }
}

resource "aws_route_table_association" "jenkins_route_table_association" {
  subnet_id      = aws_subnet.jenkins_public_subnets[each.key].id
  for_each       = var.jenkins_public_subnet_cidrs
  route_table_id = aws_route_table.jenkins_route_table[each.key].id
}

