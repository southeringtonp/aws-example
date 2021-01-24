############################################################
# VPC and Subnet Definitions
############################################################

resource "aws_vpc" "vpc1" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "Terraform VPC"
    }
}

resource "aws_subnet" "sub1" {
    vpc_id = aws_vpc.vpc1.id
    availability_zone = data.aws_availability_zones.available.names[0]
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "false"
    tags = {
        Name = "Subnet 1 - Public"
    }
}

resource "aws_subnet" "sub2" {
    vpc_id = aws_vpc.vpc1.id
    availability_zone = data.aws_availability_zones.available.names[1]
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "false"
    tags = {
        Name = "Subnet 2 - Public"
    }
}

resource "aws_subnet" "sub3" {
    vpc_id = aws_vpc.vpc1.id
    availability_zone = data.aws_availability_zones.available.names[0]
    cidr_block = "10.0.3.0/24"
    tags = {
        Name = "Subnet 3 - Private"
    }
}

resource "aws_subnet" "sub4" {
    vpc_id = aws_vpc.vpc1.id
    availability_zone = data.aws_availability_zones.available.names[1]
    cidr_block = "10.0.4.0/24"
    tags = {
        Name = "Subnet 4 - Private"
    }
}



############################################################
# Internet Connectivity
############################################################

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc1.id
    tags = {
        Name = "Internet Gateway"
    }
}


resource "aws_eip" "eip_nat" {
    vpc = true
    depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "natgw" {
    allocation_id = aws_eip.eip_nat.id
    subnet_id = aws_subnet.sub1.id
    tags = {
        Name = "NAT Gateway"
    }
    depends_on = [aws_internet_gateway.igw]
}



############################################################
# Routing
############################################################

resource "aws_route_table" "rt_public" {
    vpc_id = aws_vpc.vpc1.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "Public Route Table"
    }
}

## Change the main routing table for the **VPC** to our custom route table 
#resource "aws_main_route_table_association" "r-vpc1" {
#    vpc_id = aws_vpc.vpc1.id
#    route_table_id = aws_route_table.rt.id
#}

resource "aws_route_table_association" "r-sub1" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "r-sub2" {
    subnet_id = aws_subnet.sub2.id
    route_table_id = aws_route_table.rt_public.id
}


resource "aws_route_table" "rt_private" {
    vpc_id = aws_vpc.vpc1.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.natgw.id
    }
    tags = {
        Name = "NAT Route Table"
    }
}



resource "aws_route_table_association" "r-sub3" {
    subnet_id = aws_subnet.sub3.id
    route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "r-sub4" {
    subnet_id = aws_subnet.sub4.id
    route_table_id = aws_route_table.rt_private.id
}



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

