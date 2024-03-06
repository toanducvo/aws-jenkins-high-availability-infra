# Create an Auto Scaling Group
resource "aws_autoscaling_group" "jenkins_asg" {
  name = "Jenkins-ASG"

  desired_capacity = var.desired_capacity_on
  max_size         = var.max_size_on
  min_size         = var.min_size_on

  load_balancers = [aws_lb.jenkins_lb.id]
  health_check_type = "ELB"
  health_check_grace_period = 600

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    propagate_at_launch = true
    value = "Jenkins-ASG"
  }

  tag {
    key = "Application"
    propagate_at_launch = false
    value = "Jenkins"
  }

  availability_zones = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]

  target_group_arns = [aws_lb_target_group.jenkins_alb_target_group.arn]

  vpc_zone_identifier = [for value in aws_subnet.jenkins_public_subnets : value.id]

  # When the instances are launched, they will be provisioned using the Launch Template
  # with latest version
  launch_template {
    id      = aws_launch_template.jenkins_launch_template.id
    version = "$Latest"
  }
}

# Schedule the Jenkins EC2 instances to be online on weekdays
resource "aws_autoscaling_schedule" "jenkins-server-asg-online-weekday" {
  autoscaling_group_name = aws_autoscaling_group.jenkins_asg.name
  scheduled_action_name  = "jenkins-server-online-weekday"

  desired_capacity = var.desired_capacity_on
  max_size         = var.max_size_on
  min_size         = var.min_size_on


  # Schedule the Jenkins EC2 instances to be online on weekdays
  # This will scale up the instances at 8 AM on weekdays
  recurrence = var.on_cron_weekday
}

resource "aws_autoscaling_schedule" "jenkins-server-asg-offline-weekday" {
  autoscaling_group_name = aws_autoscaling_group.jenkins-server-asg.name
  scheduled_action_name  = "jenkins-server-offline-weekday"

  desired_capacity = var.desired_capacity_off
  max_size         = var.max_size_off
  min_size         = var.min_size_off

  # Schedule the Jenkins EC2 instances to be offline on weekdays
  # This will scale down the instances at 6 PM on weekdays
  recurrence = var.off_cron_weekday
}

# Security Group for Jenkins hosts on EC2
resource "aws_security_group" "jenkins_security_group" {
  vpc_id = aws_vpc.jenkins_vpc.id

  name        = "Jenkins-Security-Group"
  description = "Security Group for Jenkins EC2 Instance"

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = [var.cidr_block]

      # Allow traffic from the ALB to the Jenkins EC2 instance
      security_groups = [aws_security_group.jenkins_alb_security_group.id]
    }
  }

  # Allow all egress traffic
  dynamic "egress" {
    for_each = local.egress_rules

    content {
      description = egress.value.description
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = "-1"
      cidr_blocks = [var.cidr_block]
    }
  }

  tags = {
    Name = "Jenkins-Security-Group"
  }
}


