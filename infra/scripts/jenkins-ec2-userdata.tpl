#!/bin/bash

sudo systemctl stop jenkins

sudo mkdir -p ${MOUNT_POINT}
sudo mount -t efs -o tls ${EFS_DNS_NAME}:/ ${MOUNT_POINT}
sudo chown -R jenkins:jenkins ${MOUNT_POINT}
sudo usermod -d /${MOUNT_POINT} jenkins

if [ "$(ls -A /${MOUNT_POINT} | wc -l)" -eq 0 ]; then 
    sudo cp -rp /var/lib/jenkins/* /${MOUNT_POINT}
    echo "EFS mounted successfully and copied the data" > /tmp/efs_mount.log
else 
    echo "EFS mounted successfully" > /tmp/efs_mount.log
fi

sudo rm -rf /var/lib/jenkins

sudo sed -i "s|/var/lib/jenkins|/${MOUNT_POINT}|g" /usr/lib/systemd/system/jenkins.service
sudo systemctl daemon-reload

sudo systemctl start jenkins