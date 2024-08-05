#!/bin/bash

# Set default region
export AWS_DEFAULT_REGION=us-west-2

regions=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)
echo "Available AWS regions:"
select region in $regions; do
  if [ -n "$region" ]; then
    break
  else
    echo "Invalid selection"
  fi
done

echo "Selected region: $region"

export AWS_DEFAULT_REGION=$region
DEFAULT_VPC_ID=$(aws ec2 describe-vpcs --query "Vpcs[?IsDefault].VpcId" --output text)
if [ -z "$DEFAULT_VPC_ID" ]; then
  echo "No default VPC found, creating one..."
  DEFAULT_VPC_ID=$(aws ec2 create-default-vpc --query "Vpc.VpcId" --output text)
fi

echo "Using default VPC: $DEFAULT_VPC_ID in region $AWS_DEFAULT_REGION"

# instance_type_family=$(aws ec2 describe-instance-type-offerings --location-type region --filters Name=location,Values=$region --query "InstanceTypeOfferings[].InstanceType" --output text | awk -F '.' '{print $1}' | sort | uniq)
# echo "Available instance types in $region:"
# select instance_type in $instance_type_family; do
#   if [ -n "$instance_type" ]; then
#     break
#   else
#     echo "Invalid selection"
#   fi
# done
# echo "Selected instance type: $instance_type"

packer init . && packer build -var "region=$AWS_DEFAULT_REGION" -var "instance_type=t2.micro" .