
resource "aws_network_interface" "nic3" {
    subnet_id = aws_subnet.sub3.id
    private_ips = ["10.0.3.10"]
    security_groups = [ aws_security_group.sgweb.id ]   #TODO: different SF
}

resource "aws_instance" "compute3" {
    #ami = "ami-096fda3c22c1c990a"    # RHEL 8.3
    ami = data.aws_ami.rhel8.id
    instance_type = "t2.micro"
    instance_initiated_shutdown_behavior = "terminate"

    key_name = aws_key_pair.sshkey.id

    root_block_device {
        delete_on_termination = "true"
        volume_size = 20
    }

    depends_on = [aws_internet_gateway.igw]
    network_interface {
        network_interface_id = aws_network_interface.nic3.id
        device_index = 0
    }

    tags = {
        Name = "RHEL 8 Private"
    }
}

