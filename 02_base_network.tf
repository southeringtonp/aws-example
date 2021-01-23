
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "sub1" {
    vpc_id = aws_vpc.vpc1.id
    cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "sub2" {
    vpc_id = aws_vpc.vpc1.id
    cidr_block = "10.0.2.0/24"
}

resource "aws_subnet" "sub3" {
    # TODO: make sure this is *not* accessible from internet (igw/acl)
    vpc_id = aws_vpc.vpc1.id
    cidr_block = "10.0.3.0/24"
}

resource "aws_subnet" "sub4" {
    # TODO: make sure this is *not* accessible from internet (igw/acl)
    vpc_id = aws_vpc.vpc1.id
    cidr_block = "10.0.4.0/24"
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc1.id
}
