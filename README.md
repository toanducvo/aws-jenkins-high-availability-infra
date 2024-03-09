# Jenkins on AWS

I'll use IaC tools to provision and manage Jenkins on AWS. The goal is to create a Jenkins server to build and deploy applications with high availability and scalability.

The Jenkins will be started every working day at 8:00 AM and stopped at 6:00 PM. Feel free to modify the schedule as you need.

## Tools and Services

Tools and services used in this project:

- Github: Repository to store IaC code
- Terraform: Provision resources on AWS
- Packer: To build Jenkins AMI
- Ansible: To configure Jenkins

## High level design



## Infrastructure

## Steps

- Create Jenkins AMI using Packer
- Provision Jenkins Master and Agents using Terraform
- Configure Jenkins Master and Agents using Ansible
- Deploy a sample application using Jenkins

## Contributing

Feel free to contribute to this project. You can fork and create a pull request with your changes or use it under the terms of the [MIT License](./LICENSE).

## References

- [Jenkins Docs](https://www.jenkins.io/doc/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Packer](https://www.packer.io/docs)
- [Ansible](https://docs.ansible.com/ansible/latest/index.html)
- [Jenkins Server Legacy Infrastructure on EC2 and EFS](https://jarombek.com/blog/sep-27-2020-jenkins-ec2)

<p align="center">
<sub>Made with ❤︎ by <a href="https://bio.link/toan" target="_blank">Toan Duc Vo</a></sub>
</p>
