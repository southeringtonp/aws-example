############################################################
# Security Groups
############################################################

resource "aws_security_group" "sgweb" {
    name = "sgweb"
    description = "Allow Web and Management traffic"
    vpc_id = aws_vpc.vpc1.id

    ingress {
        description = "ssh"
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "http"
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "icmp"
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 0
        to_port = 0
    }

    ingress {
        description = "https"
        protocol = "tcp"
        from_port = 443
        to_port = 443
        cidr_blocks = ["0.0.0.0/0"]
    }

    # TODO: Make sure this is actually what we want
    egress {
        description = "outbound"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

