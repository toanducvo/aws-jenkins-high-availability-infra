packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }

     ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

source "amazon-ebs" "jenkins_ami" {
  ami_name      = "jenkins-ami-{{timestamp}}"
  instance_type = "t3.medium"
  region        =  "ap-southeast-1"
  ssh_username = "ec2-user"
  source_ami_filter {
    filters = {
      name                = "al2023-ami-2023.*-kernel-*-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
}

build {
  name    = "jenkins-ami"
  sources = [
    "source.amazon-ebs.jenkins_ami"
  ]

  provisioner "shell" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install python3 python3-pip -y"
    ]
  }

  provisioner "shell" {
  inline = [
     "sudo pip3 install ansible"
    ]
  }

  provisioner "ansible-local" {
    playbook_file = "jenkins-setup.yaml"
  }
}
