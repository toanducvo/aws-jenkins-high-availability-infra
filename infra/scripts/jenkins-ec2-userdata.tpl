#!/bin/bash

sudo systemctl stop jenkins

sudo mkdir -p ${MOUNT_POINT}
sudo mount -t efs -o tls ${EFS_DNS_NAME}:/ ${MOUNT_POINT}
sudo chown -R jenkins:jenkins ${MOUNT_POINT}
sudo usermod -d /home/${MOUNT_POINT} jenkins

if [ -d ${MOUNT_POINT} ] && [ "$(ls -A ${MOUNT_POINT})" ]; then
   echo "EFS mounted successfully" > /tmp/efs_mount.log
else
    sudo cp -rvf /var/lib/jenkins/* ${MOUNT_POINT}
    sudo rm -rf /var/lib/jenkins
    echo "EFS mounted successfully and copied the data" > /tmp/efs_mount.log
fi

sudo sed -i "s|/var/lib/jenkins|/${MOUNT_POINT}|g" /usr/lib/systemd/system/jenkins.service
sudo systemctl daemon-reload

sudo systemctl restart jenkins