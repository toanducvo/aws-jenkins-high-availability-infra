packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.1"
      source  = "github.com/hashicorp/amazon"
    }

     ansible = {
      version = ">= 1.1.1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

variable "region" {
  type    = string
}

variable "instance_type" {
  type    = string
}

source "amazon-ebs" "jenkins_ami" {
  ami_name      = "jenkins-ami-{{timestamp}}"
  instance_type = "${var.instance_type}"
  region        =  "${var.region}"
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
      "sleep 30",
      "sudo dnf update -y"
    ]
  }

  provisioner "shell" {
  inline = [
     "sudo dnf install python python-pip -y",     
     "sudo dnf install wget -y",
     "sudo dnf install git -y",
    ]
  }

  provisioner "shell" {
  inline = [
     "sudo pip3 install ansible"
    ]
  }

  provisioner "ansible-local" {
    playbook_file = "jenkins-image-builder/playbooks/jenkins-setup-playbook.yml"
  }
}
