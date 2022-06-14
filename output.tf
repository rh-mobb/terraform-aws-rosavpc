output rosa_subnet_ids {
    description = "ROSA Subnet IDs"
    value = module.this.private_subnets
}

output rosa_subnet_cidrs {
    description = "ROSA Subnet CIDRs"
    value = var.private_subnets_cidrs
}

output rosa_vpc_id {
    description = "ROSA VPC ID"
    value = module.this.vpc_id
}

output rosa_vpc_cidr {
    description = "ROSA VPC CIDR"
    value = var.cidr
}