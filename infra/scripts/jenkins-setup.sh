#!/bin/bash

# Install EFS mount helper
sudo yum install -y amazon-efs-utils

# Create a directory to mount the EFS
sudo mkdir -p ${MOUNT_DIR}

# Mount directory to EFS
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${EFS_DNS_NAME}:/ ${MOUNT_DIR}

# Change the owner of the directory to Jenkins
sudo chown jenkins:jenkins ${MOUNT_DIR}