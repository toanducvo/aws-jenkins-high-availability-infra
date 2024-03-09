data "template_file" "jenkins_setup_user_data" {
  template = file("${path.module}/scripts/jenkins-setup.sh")

  vars = {
    # Default DNS: file-system-id.efs.aws-region.amazonaws.com
    EFS_DNS_NAME = "${aws_efs_file_system.jenkins_efs.id}.efs.${var.aws_region}.amazonaws.com"
    MOUNT_DIR    = "/var/lib/jenkins"
  }
}