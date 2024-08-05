data "aws_ami" "jenkins-bastion-host-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-*-x86_64"]
  }
}

resource "aws_security_group" "jenkins_bastion_host_security_group" {
  name        = var.jenkins_bastion_host_security_group_name
  vpc_id      = aws_vpc.jenkins_vpc.id
  description = "Allow SSH traffic to Jenkins Bastion Host"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }
}

resource "aws_instance" "jenkins_bastion_host" {
  ami                    = data.aws_ami.jenkins-bastion-host-ami.id
  instance_type          = var.jenkins_bastion_host_instance_type
  key_name               = var.jenkins_bastion_host_key_pair_name
  vpc_security_group_ids = [aws_security_group.jenkins_bastion_host_security_group.id]

  subnet_id = aws_subnet.jenkins_public_subnets[element(local.azs, 0)].id

  tags = {
    Name = var.jenkins_bastion_host_name
  }

  depends_on = [local_file.jenkins_private_key_pem, aws_key_pair.jenkins_key_pair, aws_launch_template.jenkins_launch_template]

  # provisioner "file" {
  #   connection {
  #     type        = "ssh"
  #     user        = "ec2-user"
  #     private_key = file("${local_file.jenkins_private_key_pem.filename}")
  #     host        = self.public_ip
  #     agent       = true
  #   }

  #   source      = local_file.jenkins_private_key_pem.filename
  #   destination = "~/.ssh/${var.jenkins_key_pair_name}.pem"
  # }
}