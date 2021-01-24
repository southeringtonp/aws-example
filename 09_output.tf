
output "ec2_ami" {
    value = aws_instance.compute1.ami
}

output "public_ip_1" {
    value = aws_eip.eip1.public_ip
}

output "load_balancer_public_ip" {
    value = aws_eip.eip_lb.public_ip
}

