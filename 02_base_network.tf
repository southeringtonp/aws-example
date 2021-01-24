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
# Internet Gateways
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

resource "aws_route_table" "rt_nat" {
    vpc_id = aws_vpc.vpc1.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.natgw.id
    }
    tags = {
        Name = "NAT Route Table"
    }
}


resource "aws_route_table_association" "r-sub1" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "r-sub2" {
    subnet_id = aws_subnet.sub2.id
    route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "r-sub3" {
    subnet_id = aws_subnet.sub3.id
    route_table_id = aws_route_table.rt_nat.id
}

resource "aws_route_table_association" "r-sub4" {
    subnet_id = aws_subnet.sub4.id
    route_table_id = aws_route_table.rt_nat.id
}

