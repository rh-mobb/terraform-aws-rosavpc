# Terraform Module ROSA Private Link VPC

This is a terraform module to create a rosa VPC that:

* Has only private subnets
* Create a VPC S3 Endpoint and configure the routes
* Optionally peer with a transit gateway and configure the routes


## Input

Please Reference [variables.tf](./variables.tf)

## Output

Please Reference [output.tf](./output.tf)

## Usage

**Notes: Users are responsible to create necessary routes, so the VPC/networks can reach to the necessary internet resources either [direct routing](https://docs.openshift.com/rosa/rosa_planning/rosa-sts-aws-prereqs.html#osd-aws-privatelink-firewall-prerequisites_rosa-sts-aws-prereqs) or a [proxy](https://docs.openshift.com/rosa/networking/configuring-cluster-wide-proxy.html)**

```
module openshift_vpc {
    source = "rh-mobb/rosa-privatelink-vpc/aws"
    name = "my_rosa_vpc"
    region = "us-east-2"
    azs  = ["us-east-2a", "us-east-2b", "us-east-2c"]    
    cidr = "10.0.0.0/22"
    private_subnets_cidrs = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
    transit_gateway = {
        peer = true
        transit_gateway_id = "tgw-xxx"
        dest_cidrs = ["192.168.0.0/24, "192.168.1.0/24"]
    }
}
```