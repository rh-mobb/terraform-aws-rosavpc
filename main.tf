terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

locals {
  route-list = flatten([
    for index, subnet in var.private_subnets_cidrs :[
      for dest_cidr in var.transit_gateway.dest_cidrs : {
        index = index
        cidr   = dest_cidr
      }
    ]
  ])
}

module "this" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"
  name = var.name
  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.private_subnets_cidrs

  enable_dns_hostnames = true
  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = merge(
    { "Name" = var.name },
    var.tags,
  )
    
}

provider "aws" {
  ignore_tags {
    key_prefixes = ["kubernetes.io/"]
  }
  region = var.region
}

resource "aws_vpc_endpoint" "s3" {    
  vpc_id       = module.this.vpc_id
  service_name = "com.amazonaws.${var.region}.s3"
  lifecycle {
      ignore_changes = [
          route_table_ids,
      ]
  }
}

resource "aws_vpc_endpoint_route_table_association" "vpc_endpoint_association" {
  count = length(module.this.private_route_table_ids)
  route_table_id = module.this.private_route_table_ids[count.index]
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "rosa_vpc_attachement" {
  count = var.transit_gateway.peer ? 1 : 0
  subnet_ids         = module.this.private_subnets
  transit_gateway_id = var.transit_gateway.transit_gateway_id
  vpc_id             = module.this.vpc_id
}

resource "aws_route" "route_to_tranasit_gateway" {
  for_each = {
      for route in local.route-list : "${route.cidr}-${route.index}" => route
  }
  route_table_id              = module.this.private_route_table_ids[each.value.index]
  destination_cidr_block      = each.value.cidr
  transit_gateway_id          = var.transit_gateway.transit_gateway_id
}