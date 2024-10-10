module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name               = local.vpc_name
  cidr               = var.vpc_cidr
  azs                = var.availability_zones
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_nat_gateway = true
  single_nat_gateway = true
  create_igw         = true
  tags               = local.tags
}

module "ecs" {
  # source = "github.com/CDCgov/dibbs-aws//terraform/modules/ecs?ref=1484b28e75adccab1e7ceef3ed61890b8b01507e"
  source = "../../dibbs-aws/terraform/modules/ecs"
  public_subnet_ids  = flatten(module.vpc.public_subnets)
  private_subnet_ids = flatten(module.vpc.private_subnets)
  vpc_id             = module.vpc.vpc_id
  region             = var.region

  owner   = var.owner
  project = var.project
  tags    = local.tags

  # If intent is to pull from the phdi GHCR, set disable_ecr to true (default is false)
  # disable_ecr = true
  # If intent is to use the non-integrated viewer, set non_integrated_viewer to "true" (default is false)
  # non_integrated_viewer = "true"
  # If the intent is to make the ecr-viewer availabble on the public internet, set internal to false (default is true) This requires an internet gateway to be present in the VPC.
  # internal       = false
  internal       = false
  non_integrated_viewer = "true"
  ecr_viewer_app_env = "test"
}
