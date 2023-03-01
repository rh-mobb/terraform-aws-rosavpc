variable private_subnets_cidrs {
    description = "private subnets cidrs"
    type        = list
    default = ["10.0.0.0/24"]
}

variable public_subnets_cidrs {
    description = "public subnets cidrs"
    type        = list
    default = ["10.0.0.0/24"]
}

variable cidr {
    description = "VPC Cidr range"
    type      = string
    default   = "10.0.0.0/22"
}

variable name {
    description = "Name of the VPC"
    type    = string
}

variable azs {
    description = "A list of AZs"
    type    = list
}

variable region {
    description = "Region"
    type    = string
}

variable transit_gateway {
    description = "Peer with a transit gateway"
    type = object({
        peer = bool
        transit_gateway_id = string
        dest_cidrs = list(string)
    })
    default = {
        peer = false
        transit_gateway_id = ""
        dest_cidrs = []
    }
}

variable tags {
  description = "A map of tags to add to all resources" 
  type        = map(string)
  default     = {}
}

variable private_subnet_tags {
  description = "A map of tags to add to all private subnets" 
  type        = map(string)
  default     = {}
}

variable create_s3_vpc_endpoint {
    type = bool
    default = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}