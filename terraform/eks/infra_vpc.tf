module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.25.0"
  cidr_block = var.cidr_block
  attributes = ["vpc"]
  context    = module.label.context
}

# Deploy in all AZs
data "aws_availability_zones" "available" {
  state = "available"
}

module "subnets" {
  source                          = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.39.3"
  tags                            = tomap({ "kubernetes.io/cluster/${module.cluster_label.id}" = "shared" })
  private_subnets_additional_tags = tomap({ "kubernetes.io/role/internal-elb" = "1" })
  public_subnets_additional_tags  = tomap({ "kubernetes.io/role/elb" = "1" })
  vpc_id                          = module.vpc.vpc_id
  igw_id                          = module.vpc.igw_id
  cidr_block                      = module.vpc.vpc_cidr_block
  availability_zones              = data.aws_availability_zones.available.names
  aws_route_create_timeout        = "5m"
  aws_route_delete_timeout        = "10m"
  context                         = module.label.context
}
