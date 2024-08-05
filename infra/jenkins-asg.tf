# Create an Auto Scaling Group
resource "aws_autoscaling_group" "jenkins_asg" {
  name = var.jenkins_asg_name

  desired_capacity = 1
  max_size         = var.max_size_on
  min_size         = var.min_size_on

  target_group_arns = [aws_lb_target_group.jenkins_alb_target_group.arn]

  vpc_zone_identifier = [for value in aws_subnet.jenkins_private_subnets : value.id]

  launch_template {
    id      = aws_launch_template.jenkins_launch_template.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "Jenkins-ASG"
  }

  tag {
    key                 = "Application"
    propagate_at_launch = true
    value               = "Jenkins"
  }
}

resource "aws_security_group" "jenkins_launch_template_security_group" {
  vpc_id = aws_vpc.jenkins_vpc.id

  name = var.jenkins_launch_template_security_group_name

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.jenkins_bastion_host_security_group.id]
    description     = "SSH from Bastion Host"
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.jenkins_alb_security_group.id]
    description     = "Jenkins port from ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }
}

