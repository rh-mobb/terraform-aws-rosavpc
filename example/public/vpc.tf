module openshift_vpc {
    # source = "rh-mobb/rosavpc/aws"
    source = "../../"
    name = "examplevpc"
    region = "us-east-2"
    azs  = ["us-east-2a","us-east-2b","us-east-2c"]
    cidr = "10.0.0.0/16"
    public_subnets_cidrs = ["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24"]
    private_subnets_cidrs = ["10.0.3.0/24","10.0.4.0/24","10.0.5.0/24"]
    enable_nat_gateway = true
}