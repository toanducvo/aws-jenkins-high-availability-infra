data "template_file" "jenkins_setup_user_data" {
  template = file("${path.module}/scripts/jenkins-ec2-userdata.tpl")

  vars = {
    EFS_DNS_NAME = aws_efs_file_system.jenkins_efs.dns_name
    MOUNT_POINT  = "jenkins"
  }

  depends_on = [aws_efs_file_system.jenkins_efs]
}

data "aws_ami" "jenkins_ami" {
  most_recent = true
  owners      = ["${data.aws_caller_identity.current.account_id}"]

  filter {
    name   = "name"
    values = ["jenkins-ami-*"]
  }
}

resource "aws_launch_template" "jenkins_launch_template" {
  name        = var.jenkins_launch_template_name
  description = var.jenkins_launch_template_description

  instance_type = var.jenkins_launch_template_instance_type
  image_id      = data.aws_ami.jenkins_ami.id

  vpc_security_group_ids = [aws_security_group.jenkins_launch_template_security_group.id]

  key_name  = var.jenkins_key_pair_name
  user_data = base64encode(data.template_file.jenkins_setup_user_data.rendered)
}
