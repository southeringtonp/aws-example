############################################################
# Provider configuration
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
#
# Note: AWS credentials and region are intentionally omitted
#       on the assumption that they will be handled externally
#       to terraform.
#
############################################################

terraform {
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

