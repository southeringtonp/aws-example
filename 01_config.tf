############################################################
# Variable, Parameters, Lookups
############################################################

# should be generated separately ahead of time
resource "aws_key_pair" "sshkey" {
    key_name = "terraform-key"
    public_key = file("./id_terraform.pub")
}

# Automatically enumerate availability zones
data "aws_availability_zones" "available" {
    # Enumerate the availability zones for the region
    state = "available"
}


# Find the latest Red Hat 8 AMI
# For filter values see https://access.redhat.com/solutions/15356
# In testing under region us-east-1, this was: ami-096fda3c22c1c990a
data "aws_ami" "rhel8" {
    most_recent = true

    owners = ["309956199498"]
    filter {
        name = "name"
        values = ["RHEL-8*"]
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


