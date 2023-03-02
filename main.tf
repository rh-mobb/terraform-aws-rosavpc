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
  public_subnets = var.public_subnets_cidrs

  enable_dns_hostnames = true
  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = false
  single_nat_gateway = var.single_nat_gateway

  private_subnet_tags = var.private_subnet_tags  
  public_subnet_tags = var.public_subnet_tags  

  tags = merge(
    { "Name" = var.name },
    var.tags,
  )
    
}

module aws_vpc_endpoint {
  source = "./s3_vpc_endpoint"
  count = var.create_s3_vpc_endpoint ? 1 : 0
  vpc_id = module.this.vpc_id
  route_table_ids = module.this.private_route_table_ids
  region = var.region
}

resource "aws_ec2_transit_gateway_vpc_attachment" "rosa_vpc_attachment" {
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
