variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "ap-southeast-1"
}




### Availability Zones

variable "azs" {
  type = list(string)
  description = "Availability zones"
  default = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
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
  type        = map(string)
  description = "CIDR block for the public subnets in each availability zone"
  default = {
    "ap-southeast-1a" : "10.0.0.0/24",
    "ap-southeast-1b" : "10.0.1.0/24",
    "ap-southeast-1c" : "10.0.2.0/24"
  }
}


variable "jenkins_private_subnet_name" {
  type        = string
  description = "Name of the public subnets"
  default     = "Jenkins-Private-Subnets"
}

variable "jenkins_private_subnet_cidrs" {
  type        = map(string)
  description = "CIDR block for the private subnets in each availability zone"
  default = {
    "ap-southeast-1a" : "10.0.100.0/24",
    "ap-southeast-1b" : "10.0.101.0/24",
    "ap-southeast-1c" : "10.0.102.0/24"
  }
}

variable "jenkins_igw_name" {
  type        = string
  description = "Name of the internet gateway"
  default     = "Jenkins-Internet-Gateway"
}

variable "jenkins_route_table" {
  type        = string
  description = "Name of the route table"
  default     = "Jenkins-Public-Route-Table"
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

variable "jenkins_schedule_time_zone" {
  description = "Time zone for the scheduled actions"
  type        = string
  default     = "Asia/Ho_Chi_Minh"
}

variable "max_size_on" {
  description = "Maximum size of the autoscaling group when it is online"
  type        = number
  default     = 2
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

variable "on_cron_weekday" {
  description = "Cron expression for scaling up the instances on weekdays"
  type        = string
  default     = "0 8 * * MON-FRI"
}

variable "on_cron_weekday_action_name" {
  description = "Name of the scheduled action for scaling up the instances on weekdays"
  type        = string
  default     = "Jenkins server online on weekdays"
}

variable "max_size_off" {
  description = "Maximum size of the autoscaling group when it is offline"
  type        = number
  default     = 0
}

variable "min_size_off" {
  description = "Minimum size of the autoscaling group when it is offline"
  type        = number
  default     = 0
}

variable "desired_capacity_off" {
  description = "Desired capacity of the autoscaling group when it is offline"
  type        = number
  default     = 0
}

variable "off_cron_weekday" {
  description = "Cron expression for scaling down the instances on weekdays"
  type        = string
  default     = "0 18 * * MON-FRI"
}

variable "off_cron_weekday_action_name" {
  description = "Name of the scheduled action for scaling down the instances on weekdays"
  type        = string
  default     = "Jenkins server offline on weekdays"
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

variable "jenkins_private_key" {
  description = "Path to the private key"
  type        = string
  default     = "jenkins-key-pair.pem"
}

variable "jenkins_launch_template_security_group_name" {
  description = "Name of the security group for the EC2 instance"
  type        = string
  default     = "Jenkins-Security-Group"
}

variable "jenkins_launch_template_security_group_description" {
  description = "Description of the security group for the EC2 instance"
  type        = string
  default     = "Security Group for Jenkins EC2 Instance"
}




### SSM Parameter Variables

variable "jenkins_key_pair_ssm_parameter_name" {
  description = "Name of the SSM parameter"
  type        = string
  default     = "/jenkins/key_pair"
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

variable "jenkins_efs_security_group_description" {
  description = "Description of the security group for the EFS"
  type        = string
  default     = "Security Group for Jenkins EFS"
}
