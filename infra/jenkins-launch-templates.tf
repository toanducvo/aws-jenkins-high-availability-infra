resource "aws_launch_template" "jenkins_launch_template" {
  name        = var.jenkins_launch_template_name
  description = var.jenkins_launch_template_description

  instance_type = var.jenkins_launch_template_instance_type



  vpc_security_group_ids = [aws_security_group.jenkins_launch_template_security_group.id]

  key_name  = var.jenkins_key_pair_name
  user_data = data.template_file.jenkins_setup_user_data.rendered
}

