# Jenkins infrastructure with Terraform

This folder contains the Terraform code to create the infrastructure for Jenkins.

## Prerequisites

If you want to run this code, you need to have the following installed:

- AWS CLI
- Terraform CLI
- AWS account

> **Note:** If you intend to use [DevContainer](https://code.visualstudio.com/docs/remote/containers) with Visual Studio Code, please refer to the `.devcontainer` folder in the root of this repository for the required extensions and configurations.

## Overview

```bash
.
├── data.tf # Data sources
├── jenkins-alb.tf # Application Load Balancer
├── jenkins-asg.tf # Auto Scaling Group
├── jenkins-efs.tf # Elastic File System
├── jenkins-launch-templates.tf # Launch Templates
├── key-pairs.tf # Key Pairs
├── outputs.tf # Outputs
├── providers.tf # Providers
├── README.md
├── scripts # Configuration scripts
│   └── jenkins-setup.sh # EC2 instance setup script
├── ssm_parameter.tf # SSM Parameters
├── variables.tf # Variables
└── vpc.tf # VPC
```

## Usage

1. Run `terraform init` to initialize the working directory and download the provider plugins.
2. Run `terraform plan` to create an execution plan.
3. Run `terraform apply` to apply the desired changes.
