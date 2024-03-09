resource "null_resource" "create_key_pair" {
  triggers = {
    key_name    = var.jenkins_key_pair_name
    private_key = var.jenkins_private_key
  }

  provisioner "local-exec" {
    when    = create
    command = "test -f ${self.triggers.private_key} || aws ec2 create-key-pair --key-name ${self.triggers.key_name} --query 'KeyMaterial' --output text > ${self.triggers.private_key} && chmod 400 ${self.triggers.private_key}"
  }
}

resource "null_resource" "delete_key_pair" {
  triggers = {
    key_name    = var.jenkins_key_pair_name
    private_key = var.jenkins_private_key
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws ec2 delete-key-pair --key-name ${self.triggers.key_name}"
  }
}