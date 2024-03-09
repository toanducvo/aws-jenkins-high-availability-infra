locals {
  jenkins_launch_template_ingress_rules = [
    {
      port        = 8080
      description = "Allow Jenkins traffic"
      protocol    = "TCP"
    },
    {
      port        = 22
      description = "Allow SSH access"
      protocol    = "TCP"
  }]

  jenkins_launch_template_egress_rules = [{
    port        = 0
    description = "Allow all Egress traffic"
  }]

}


# Create an Auto Scaling Group
resource "aws_autoscaling_group" "jenkins_asg" {
  name = var.jenkins_asg_name

  desired_capacity = var.desired_capacity_on
  max_size         = var.max_size_on
  min_size         = var.min_size_on

  load_balancers = [aws_lb.jenkins_lb.id]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "Jenkins-ASG"
  }

  tag {
    key                 = "Application"
    propagate_at_launch = false
    value               = "Jenkins"
  }

  availability_zones = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]

  target_group_arns = [aws_lb_target_group.jenkins_alb_target_group.arn]

  vpc_zone_identifier = [for value in aws_subnet.jenkins_public_subnets : value.id]

  launch_template {
    id      = aws_launch_template.jenkins_launch_template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_schedule" "jenkins-server-asg-online-weekday" {
  autoscaling_group_name = aws_autoscaling_group.jenkins_asg.name
  scheduled_action_name  = var.on_cron_weekday_action_name

  desired_capacity = var.desired_capacity_on
  max_size         = var.max_size_on
  min_size         = var.min_size_on

  recurrence = var.on_cron_weekday

  time_zone = var.jenkins_schedule_time_zone
}

resource "aws_autoscaling_schedule" "jenkins-server-asg-offline-weekday" {
  autoscaling_group_name = aws_autoscaling_group.jenkins_asg.name
  scheduled_action_name  = var.off_cron_weekday_action_name

  desired_capacity = var.desired_capacity_off
  max_size         = var.max_size_off
  min_size         = var.min_size_off

  recurrence = var.off_cron_weekday

  time_zone = var.jenkins_schedule_time_zone
}

resource "aws_security_group" "jenkins_security_group" {
  vpc_id = aws_vpc.jenkins_vpc.id

  name        = var.jenkins_launch_template_security_group_name
  description = var.jenkins_launch_template_security_group_description

  dynamic "ingress" {
    for_each = local.jenkins_launch_template_ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = [var.cidr_block]

      security_groups = [aws_security_group.jenkins_alb_security_group.id]
    }
  }

  dynamic "egress" {
    for_each = local.jenkins_launch_template_egress_rules

    content {
      description = egress.value.description
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = "-1"
      cidr_blocks = [var.cidr_block]
    }
  }
}


