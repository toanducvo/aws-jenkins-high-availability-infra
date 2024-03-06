variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "ap-southeast-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.16.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = map(string)
  description = "CIDR block for the public subnets in each availability zone"
  default = {
    "ap-southeast-1a" : "10.0.0.0/24",
    "ap-southeast-1b" : "10.0.1.0/24",
    "ap-southeast-1c" : "10.0.2.0/24"
  }
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the route table"
  default     = "0.0.0.0/0"
}

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




### Autoscaling Group Variables

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

variable "on_cron_weekday" {
  description = "Cron expression for scaling up the instances on weekdays"
  type        = string
  default     = "0 8 * * MON-FRI"
}

variable "off_cron_weekday" {
  description = "Cron expression for scaling down the instances on weekdays"
  type        = string
  default     = "0 18 * * MON-FRI"
}




### ELB Variables






### EC2 Variables

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t3.medium"
}