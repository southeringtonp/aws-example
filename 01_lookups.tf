
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami#image_owner_alias
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

data "aws_ami" "rhel8" {
    # Find the latest Red Hat 8 AMI
    # For filter values see https://access.redhat.com/solutions/15356
    # TODO: Adjust for current region?
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
