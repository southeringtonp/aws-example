#https://registry.terraform.io/providers/hashicorp/aws/latest/docs

terraform {
  # TODO: Specify region, instance ID for AMI
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Key pair for compute resources
resource "aws_key_pair" "sshkey" {
    key_name = "terraform-key"
    public_key = file("./id_rsa.pub")
}
