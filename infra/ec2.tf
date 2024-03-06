# The instances will be provisioned using the Launch Template
resource "aws_launch_template" "jenkins_launch_template" {

  instance_type = var.instance_type
  


  vpc_security_group_ids = [aws_security_group.jenkins_security_group.id]

  tags = {
    Name = "Jenkins-Instance-Template"
  }
}