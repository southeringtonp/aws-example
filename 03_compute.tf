
resource "aws_network_interface" "nic1" {
    subnet_id = aws_subnet.sub1.id
    private_ips = ["10.0.1.10"]
}

resource "aws_instance" "compute1" {
    #TODO: find the ami id programmatically or move to config file
    # For now get from https://cloud-images.ubuntu.com/locator/ec2/
    # aws ec2 describe-images --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server*" --query 'Images[*].[ImageId,CreationDate]' --output text | sort -k2 -r | head -n 1 | awk {'print $1'}
    ami = "ami-0f2a394c7ec0966c2"
    instance_type = "t2.micro"

    network_interface {
        network_interface_id = aws_network_interface.nic1.id
        device_index = 0
    }
}
