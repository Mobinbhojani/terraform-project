module "ec2" {
  source = "../modules/ec2/"

  instance-type         = var.instance-type
  ami-id                = var.ami-id
  key-name              = var.key-name
  subnet_id             = module.vpc.public_subnet_id
  security_group_ids    = [module.vpc.sg_id]
  tags                  = local.common_tags
  environment           = prod
}
