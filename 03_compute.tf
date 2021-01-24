
resource "aws_network_interface" "nic1" {
    subnet_id = aws_subnet.sub1.id
    private_ips = ["10.0.1.10"]
    security_groups = [ aws_security_group.sgweb.id ]
}

resource "aws_instance" "compute1" {
    #TODO: find the ami id programmatically or move to config file
    # For now get from https://cloud-images.ubuntu.com/locator/ec2/
    # or CLI, adapted from https://gist.github.com/vancluever/7676b4dafa97826ef0e9
    # aws ec2 describe-images --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server*" --query 'Images[*].[ImageId,CreationDate]' --output text | sort -k2 -r | head -n 1 | awk {'print $1'}

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
        network_interface_id = aws_network_interface.nic1.id
        device_index = 0
    }

    tags = {
        Name = "RHEL 8 Public"
    }
}

resource "aws_eip" "eip1" {
    vpc = true
    instance = aws_instance.compute1.id
    depends_on = [aws_internet_gateway.igw]
}


