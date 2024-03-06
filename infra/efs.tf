resource "aws_efs_file_system" "jenkins_efs" {
  creation_token = "jenkins-fs"

  tags = {
    Name = "Jenkins-EFS"
  }
}

resource "aws_security_group" "jenkins_efs_security_group" {
  vpc_id = aws_vpc.jenkins_vpc.id

  name        = "Jenkins-EFS-Security-Group"
  description = "Security Group for Jenkins EFS"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  tags = {
    Name = "Jenkins-EFS-Security-Group"
  }
  
}

resource "aws_efs_mount_target" "jenkins_efs_mount" {
  file_system_id = aws_efs_file_system.jenkins-efs.id
  for_each = var.public_subnet_cidrs
  subnet_id  = aws_subnet.jenkins_public_subnets[each.key].id
  security_groups = [aws_security_group.jenkins_efs_security_group.id]
}
