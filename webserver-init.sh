#!/bin/sh
yum update
yum install -y httpd
systemctl enable httpd
systemctl start httpd
