# Terraform Module ROSA VPC

This is a terraform module to create a rosa VPC that:

* Optionally to have public subnets
* Optionally Create a VPC S3 Endpoint and configure the routes
* Optionally peer with a transit gateway and configure the routes

## Usage

**Notes: Users are responsible to create necessary routes, so the VPC/networks can reach to the necessary internet resources either [direct routing](https://docs.openshift.com/rosa/rosa_planning/rosa-sts-aws-prereqs.html#osd-aws-privatelink-firewall-prerequisites_rosa-sts-aws-prereqs) or a [proxy](https://docs.openshift.com/rosa/networking/configuring-cluster-wide-proxy.html)**

## With Public Subnet and Internet Gateway
```
module openshift_vpc {
    source = "rh-mobb/rosavpc/aws"
    name = "examplerosavpc"
    region = "us-east-2"
    azs  = ["us-east-2a","us-east-2b","us-east-2c"]
    cidr = "10.0.0.0/22"
    public_subnets_cidrs = ["10.0.3.0/26","10.0.3.64/26","10.0.3.128/26"]
    private_subnets_cidrs = ["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24"]
    enable_nat_gateway = true
}
```

## Only With Private Subnets and Route through a Transit Gateway

```
module openshift_vpc {
    source = "rh-mobb/rosavpc/aws"
    name = "examplerosavpc"
    region = "us-east-2"
    azs  = ["us-east-2a","us-east-2b","us-east-2c"]
    cidr = "10.0.0.0/22"
    private_subnets_cidrs = ["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24"]
    transit_gateway = {
        peer = true
        transit_gateway_id = module.tgw.ec2_transit_gateway_id
        dest_cidrs = [var.vpn_cidr, "192.168.0.0/24"]
    }
}
```