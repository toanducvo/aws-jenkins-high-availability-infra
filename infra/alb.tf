# Application Load Balancer for Jenkins
# This helps to distribute traffic across the Jenkins EC2 instances
# if there are multiple instances provisioned by the Auto Scaling Group
resource "aws_lb" "jenkins_lb" {
  name               = var.app_alb
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.jenkins_security_group.id]
  subnets            = [for value in aws_subnet.jenkins_public_subnets : value.id]

  tags = {
    Name = "Jenkins-ALB"
  }
}


# Target Group for Jenkins Application Load Balancer
# When the ALB receives a request, it forwards the request to the target group
resource "aws_lb_target_group" "jenkins_alb_target_group" {
  vpc_id = aws_vpc.jenkins_vpc.id

  port     = 8080
  protocol = "HTTP"

  health_check {
    protocol = "HTTP"
    port     = 8080
  }

  tags = {
    Name = "Jenkins-ALB-Target-Group"
  }
}

# Listener for Jenkins Application Load Balancer
# This will listen on specific port and forward the request to the target group
resource "aws_lb_listener" "jenkins_alb_listener" {
  load_balancer_arn = aws_lb.jenkins_lb.arn
  port              = [443]
  protocol          = ["HTTPS"]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_alb_target_group.arn
  }

  tags = {
    Name = "Jenkins-ALB-Listener"
  }
}

# Security Group for Jenkins Application Load Balancer
# This will allow traffic from the internet to the ALB
resource "aws_security_group" "jenkins_alb_security_group" {
  name        = "Jenkins-ALB-Security-Group"
  description = "Security Group for Jenkins Application Load Balancer"
  vpc_id      = aws_vpc.jenkins_vpc.id

  # Allow traffic from the internet to the ALB
  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = [var.cidr_block]
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
    Name = "Jenkins-ALB-Security-Group"
  }
}