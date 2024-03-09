locals {
  jenkins_efs_ingress_rules = [{
    port        = 2049
    description = "Allow NFS traffic from EC2 instances"
    protocol    = "tcp"
  }]

  jenkins_efs_egress_rules = [{
    port        = 0
    description = "Allow all Egress traffic"
  }]
}

resource "aws_efs_file_system" "jenkins_efs" {
  creation_token = var.jenkins_efs_creation_token

  tags = {
    Name = var.jenkins_efs_name
  }
}

resource "aws_security_group" "jenkins_efs_security_group" {
  vpc_id = aws_vpc.jenkins_vpc.id

  name        = var.jenkins_efs_security_group_name
  description = var.jenkins_efs_security_group_description

  dynamic "ingress" {
    for_each = local.jenkins_efs_ingress_rules
    content {
      from_port       = ingress.value.port
      to_port         = ingress.value.port
      protocol        = ingress.value.protocol
      description     = ingress.value.description
      security_groups = [aws_security_group.jenkins_launch_template_security_group.id]
    }
  }

  dynamic "egress" {
    for_each = local.jenkins_efs_egress_rules
    content {
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = "-1"
      description = egress.value.description
      cidr_blocks = [var.cidr_block]
    }
  }
}


resource "aws_efs_mount_target" "jenkins_efs_mount" {
  file_system_id  = aws_efs_file_system.jenkins_efs.id
  for_each        = var.jenkins_public_subnet_cidrs
  subnet_id       = aws_subnet.jenkins_public_subnets[each.key].id
  security_groups = [aws_security_group.jenkins_efs_security_group.id]
}
