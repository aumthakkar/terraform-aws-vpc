module "networking" {
  source = "./networking"

  vpc_cidr = "10.0.0.0/16"

  public_sn_count = 2
  public_cidr     = [for i in range(2, 255, 2) : cidrsubnet("10.0.0.0/16", 8, i)]

  private_sn_count = 3
  private_cidr     = [for i in range(1, 255, 2) : cidrsubnet("10.0.0.0/16", 8, i)]

  security_groups = local.security_groups
  open            = var.open

  db_subnet_group = true

}