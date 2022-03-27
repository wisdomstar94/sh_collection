#!/bin/bash
sed -i'' -r -e "/\#PermitRootLogin\syes/c\PermitRootLogin yes" /etc/ssh/sshd_config
echo "y" | cp /home/ec2-user/.ssh/authorized_keys /root/.ssh/
systemctl restart sshd.service 
