variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "ap-southeast-1"
}

### VPC

variable "cidr_block" {
  type        = string
  description = "CIDR block to allow all traffic"
  default     = "0.0.0.0/0"
}

variable "jenkins_vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "Jenkins-VPC"
}

variable "jenkins_vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "jenkins_public_subnet_name" {
  type        = string
  description = "Name of the public subnets"
  default     = "Jenkins-Public-Subnets"
}

variable "jenkins_public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR block for the public subnets in each availability zone"
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}


variable "jenkins_private_subnet_name" {
  type        = string
  description = "Name of the public subnets"
  default     = "Jenkins-Private-Subnets"
}

variable "jenkins_private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR block for the private subnets in each availability zone"
  default     = ["10.0.100.0/24", "10.0.101.0/24", "10.0.102.0/24"]
}

### ELB Variables

variable "app_alb" {
  description = "Name of Application Load Balancer"
  type        = string
  default     = "Jenkins-ALB"
}

variable "alb_internal" {
  description = "Boolean to create an internal or external ALB"
  type        = bool
  default     = false
}

variable "load_balancer_type" {
  description = "Type of load balancer"
  type        = string
  default     = "application"
}

variable "load_balancer_target_group_name" {
  description = "Name of the target group"
  type        = string
  default     = "Jenkins-ALB-Target-Group"
}

variable "load_balancer_listener_name" {
  description = "Name of the load balancer listener"
  type        = string
  default     = "Jenkins-ALB-Listener"
}

variable "load_balancer_listener_default_action_type" {
  description = "Type of default action for the load balancer listener"
  type        = string
  default     = "forward"
}


### Autoscaling Group Variables

variable "jenkins_asg_name" {
  description = "Name of the autoscaling group"
  type        = string
  default     = "Jenkins-ASG"
}

variable "max_size_on" {
  description = "Maximum size of the autoscaling group when it is online"
  type        = number
  default     = 3
}

variable "min_size_on" {
  description = "Minimum size of the autoscaling group when it is online"
  type        = number
  default     = 1
}

variable "desired_capacity_on" {
  description = "Desired capacity of the autoscaling group when it is online"
  type        = number
  default     = 2
}

### Launch Template Variables

variable "jenkins_launch_template_name" {
  description = "Name of the EC2 instance"
  type        = string
  default     = "Jenkins-Instance-Template"
}

variable "jenkins_launch_template_description" {
  description = "Description of the EC2 instance"
  type        = string
  default     = "Launch Template for Jenkins EC2 Instances"
}

variable "jenkins_launch_template_instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t3.medium"
}

variable "jenkins_key_pair_name" {
  description = "Name of the key pair"
  type        = string
  default     = "jenkins-key-pair"
}

variable "jenkins_launch_template_security_group_name" {
  description = "Name of the security group for the EC2 instance"
  type        = string
  default     = "Jenkins-Security-Group"
}

### EFS Variables

variable "jenkins_efs_creation_token" {
  description = "Creation token for the EFS"
  type        = string
  default     = "jenkins-fs"
}

variable "jenkins_efs_name" {
  description = "Name of the EFS"
  type        = string
  default     = "Jenkins-EFS"

}

variable "jenkins_efs_security_group_name" {
  description = "Name of the security group for the EFS"
  type        = string
  default     = "Jenkins-EFS-Security-Group"
}

### Jenkins Bastion Host Variables

variable "jenkins_bastion_host_instance_type" {
  description = "Type of the bastion host instance"
  type        = string
  default     = "t3.micro"
}

variable "jenkins_bastion_host_name" {
  description = "Name of the bastion host"
  type        = string
  default     = "Jenkins-Bastion-Host"
}

variable "jenkins_bastion_host_security_group_name" {
  description = "Name of the security group for the bastion host"
  type        = string
  default     = "Jenkins-Bastion-Host-Security-Group"
}

variable "jenkins_bastion_host_key_pair_name" {
  description = "Name of the key pair for the bastion host"
  type        = string
  default     = "jenkins-bastion-key-pair"
}