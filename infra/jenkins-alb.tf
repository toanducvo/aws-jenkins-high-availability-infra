locals {
  jenkins_alb_ingress_rules = [
    {
      port        = 443
      description = "Allow HTTPS traffic"
      protocol    = "HTTPS"
      }, {
      port        = 80
      description = "Allow HTTP traffic"
      protocol    = "HTTP"
  }]

  jenkins_alb_egress_rules = [{
    port        = 0
    description = "Allow all Egress traffic"
  }]
}

resource "aws_lb" "jenkins_lb" {
  name               = var.app_alb
  internal           = var.alb_internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.jenkins_alb_security_group.id]
  subnets            = [for value in aws_subnet.jenkins_public_subnets : value.id]
}

resource "aws_lb_target_group" "jenkins_alb_target_group" {
  vpc_id = aws_vpc.jenkins_vpc.id

  port     = "8080"
  protocol = "HTTP"

  tags = {
    Name = var.load_balancer_target_group_name
  }
}

resource "aws_lb_listener" "jenkins_alb_listener" {
  load_balancer_arn = aws_lb.jenkins_lb.arn
  port              = local.jenkins_alb_ingress_rules[1].port
  protocol          = local.jenkins_alb_ingress_rules[1].protocol

  default_action {
    type             = var.load_balancer_listener_default_action_type
    target_group_arn = aws_lb_target_group.jenkins_alb_target_group.arn
  }

  tags = {
    Name = var.load_balancer_listener_name
  }
}

resource "aws_security_group" "jenkins_alb_security_group" {
  name        = "Jenkins-ALB-Security-Group"
  description = "Security Group for Jenkins Application Load Balancer"
  vpc_id      = aws_vpc.jenkins_vpc.id

  dynamic "ingress" {
    for_each = local.jenkins_alb_ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = [var.cidr_block]
    }
  }

  dynamic "egress" {
    for_each = local.jenkins_alb_egress_rules

    content {
      description = egress.value.description
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = "-1"
      cidr_blocks = [var.cidr_block]
    }
  }
}