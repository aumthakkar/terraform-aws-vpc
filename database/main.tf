resource "aws_db_instance" "pht_db" {
  allocated_storage = var.db_storage

  engine         = "mysql"
  engine_version = var.db_engine_version

  instance_class = var.db_instance_class

  db_name    = var.dbname
  username   = var.dbuser
  password   = var.dbpassword
  identifier = var.db_identifier

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids

  skip_final_snapshot = var.skip_db_snapshot

  tags = {
    Name = "${var.dbname}-db"
  }

}