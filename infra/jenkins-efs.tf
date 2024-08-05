resource "aws_efs_file_system" "jenkins_efs" {
  creation_token = var.jenkins_efs_creation_token

  tags = {
    Name = var.jenkins_efs_name
  }
}

resource "aws_security_group" "jenkins_efs_security_group" {
  vpc_id = aws_vpc.jenkins_vpc.id

  name        = var.jenkins_efs_security_group_name
  description = "Allow traffic to Jenkins EFS"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.jenkins_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.jenkins_vpc.cidr_block]
  }
}

resource "aws_efs_mount_target" "jenkins_efs_mount" {
  file_system_id  = aws_efs_file_system.jenkins_efs.id
  for_each        = local.private_subnet_cidrs
  subnet_id       = aws_subnet.jenkins_private_subnets[each.value.availability_zone].id
  security_groups = [aws_security_group.jenkins_efs_security_group.id]
}