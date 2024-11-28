# ---root/main.tf --- 

module "networking" {
  source = "./networking"

  vpc_cidr = local.vpc_cidr

  public_sn_count = 2
  public_cidr     = [for i in range(2, 255, 2) : cidrsubnet("10.0.0.0/16", 8, i)]

  private_sn_count = 3
  private_cidr     = [for i in range(1, 255, 2) : cidrsubnet("10.0.0.0/16", 8, i)]

  security_groups = local.security_groups
  open            = var.open

  db_subnet_group = true

}

module "database" {
  source = "./database"

  db_storage        = 10
  db_engine_version = "8.0.39"
  db_instance_class = "db.t3.micro"

  dbname     = var.dbname
  dbuser     = var.dbuser
  dbpassword = var.dbpassword

  db_subnet_group_name   = module.networking.db_subnet_group_name[0]
  vpc_security_group_ids = [module.networking.db_security_groups]

  db_identifier = "pht-db"

  skip_db_snapshot = true
}

module "loadbalancer" {
  source = "./loadbalancer"
  # LB variable values

  public_sg      = module.networking.public_security_groups
  public_subnets = module.networking.public_subnets

  # LB target_group variable values

  vpc_id = module.networking.vpc_id

  tg_port     = 8000
  tg_protocol = "HTTP"

  tg_healthy_threshold   = 2
  tg_unhealthy_threshold = 2
  tg_timeout             = 3
  tg_interval            = 30

  # LB Listener Variable values

  lb_port     = 80
  lb_protocol = "HTTP"


}