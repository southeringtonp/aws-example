
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami#image_owner_alias


# Find the latest Ubuntu 20.04 LTS AMI
# TODO: make sure this only gets official builds
data "aws_ami" "ubuntu" {
    most_recent = true
    name_regex = "^ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server"
    owners = ["aws-marketplace"]

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server"]
    }

    filter {
        name = "architecture"
        values = ["x86_64"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

}
