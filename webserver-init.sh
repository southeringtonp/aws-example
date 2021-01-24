#!/bin/sh
echo "-------------------------"
set
echo "-------------------------"
yum update
yum install -y httpd
systemctl enable httpd
systemctl start httpd
