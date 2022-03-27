#!/bin/bash

sed -i'' -r -e "/\#PermitRootLogin\sprohibit-password/a\PermitRootLogin yes" /etc/ssh/sshd_config
echo "y" | cp /home/ubuntu/.ssh/authorized_keys /root/.ssh/
systemctl restart sshd.service 
