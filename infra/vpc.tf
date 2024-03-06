# VPC for Jenkins
resource "aws_vpc" "jenkins_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "jenkins-vpc"
  }
}

# Public Subnets for Jenkins
# each availability zone will have a public subnet
resource "aws_subnet" "jenkins_public_subnets" {
  vpc_id                  = aws_vpc.jenkins_vpc.id
  for_each                = var.public_subnet_cidrs
  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Jenkins-Public-Subnets"
  }
}

# Internet Gateway for Jenkins
# This will allow the Jenkins VPC to connect to the internet
resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = {
    Name = "Jenkins-Internet-Gateway"
  }
}

# Route Table for Jenkins
# This will route traffic from the public subnets to the internet gateway
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

# Route Table Association for Jenkins
# This will associate the route table with the public subnets
resource "aws_route_table_association" "jenkins_route_table_association" {
  subnet_id      = aws_subnet.jenkins_public_subnets[each.key].id
  for_each       = var.public_subnet_cidrs
  route_table_id = aws_route_table.jenkins_route_table[each.key].id
}

