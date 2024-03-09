resource "aws_ssm_parameter" "jenkins_key_pair" {
  name  = var.jenkins_key_pair_ssm_parameter_name
  type  = "String"
  value = file("${path.module}/${var.jenkins_key_pair_name}.pem")

  depends_on = [
    null_resource.create_key_pair
  ]

  provisioner "local-exec" {
    when    = create
    command = "test -f ${self.triggers.private_key} && rm -f ${self.triggers.private_key}"
  }
}