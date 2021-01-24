############################################################
# Security Groups
############################################################

resource "aws_security_group" "sg_ssh" {
    name = "sg_ssh"
    description = "SSH Management only"
    vpc_id = aws_vpc.vpc1.id

    ingress {
        description = "ssh"
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "outbound"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "SSH from Any"
    }
}


resource "aws_security_group" "sg_web" {
    name = "sg_web"
    description = "Allow Web and local management traffic"
    vpc_id = aws_vpc.vpc1.id

    ingress {
        description = "ssh"
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = ["10.0.0.0/16"]
    }

    ingress {
        description = "icmp"
        protocol = "icmp"
        from_port = -1
        to_port = -1
        cidr_blocks = ["10.0.0.0/16"]
    }

    ingress {
        description = "http"
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "outbound"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Web and Local SSH"
    }
}

