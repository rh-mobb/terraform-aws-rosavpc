variable token {
    type = string
}

variable operator_role_prefix {
    type = string
    default = "examplevpc-0x5z"
}

locals {
  sts_roles = {
      role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ManagedOpenShift-Installer-Role",
      support_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ManagedOpenShift-Support-Role",
      instance_iam_roles = {
        master_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ManagedOpenShift-ControlPlane-Role",
        worker_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ManagedOpenShift-Worker-Role"
      },
      operator_role_prefix = var.operator_role_prefix,
  }
}

data "aws_caller_identity" "current" {}

resource "ocm_cluster_rosa_classic" "rosa_sts_cluster" {
  name           = "examplevpc"
  cloud_region   = "us-east-2"
  aws_account_id     = data.aws_caller_identity.current.account_id
  aws_subnet_ids = concat(module.openshift_vpc.rosa_public_subnet_ids, module.openshift_vpc.rosa_subnet_ids)
  machine_cidr = module.openshift_vpc.rosa_vpc_cidr
  multi_az = true
  disable_waiting_in_destroy = false
  availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]
  properties = {
    rosa_creator_arn = data.aws_caller_identity.current.arn
  }
  sts = local.sts_roles
}

resource "ocm_cluster_wait" "rosa_cluster" {
  cluster = ocm_cluster_rosa_classic.rosa_sts_cluster.id
}

module operator_roles {
    source = "terraform-redhat/rosa-sts/aws"
    version = "0.0.1"

    cluster_id = ocm_cluster_rosa_classic.rosa_sts_cluster.id
    rh_oidc_provider_thumbprint = ocm_cluster_rosa_classic.rosa_sts_cluster.sts.thumbprint
    rh_oidc_provider_url = ocm_cluster_rosa_classic.rosa_sts_cluster.sts.oidc_endpoint_url

    operator_roles_properties = data.ocm_rosa_operator_roles.operator_roles.operator_iam_roles
}

data "ocm_rosa_operator_roles" "operator_roles" {
  operator_role_prefix = var.operator_role_prefix
}