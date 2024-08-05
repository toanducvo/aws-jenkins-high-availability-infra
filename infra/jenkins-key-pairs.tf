resource "tls_private_key" "jenkins_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "jenkins_private_key_pem" {
  content         = tls_private_key.jenkins_key_pair.private_key_pem
  filename        = "${var.jenkins_key_pair_name}.pem"
  file_permission = 0400

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_key_pair" "jenkins_key_pair" {
  key_name   = var.jenkins_key_pair_name
  public_key = tls_private_key.jenkins_key_pair.public_key_openssh
}