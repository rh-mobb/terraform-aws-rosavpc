terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 4.37"
    }
    ocm = {
      version = "0.0.2"
      source  = "terraform-redhat/ocm"
    }    
  }
}

provider "aws" {
  ignore_tags {
    key_prefixes = ["kubernetes.io/"]
  }
  region = "us-east-2"
}

provider "ocm" {
  token = var.token
}