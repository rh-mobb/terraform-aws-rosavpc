variable private_subnets_cidrs {
    description = "private subnets cidrs"
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