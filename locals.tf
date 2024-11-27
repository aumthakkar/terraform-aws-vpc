locals {
  vpc_cidr = "10.0.0.0/16"
}

locals {
  security_groups = {
    public_sg = {
      name        = "pht-public-security-group"
      description = "Public Security Group"
      tags = {
        Name = "public-sg"
      }

      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }

        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = [var.open]
        }
      }
    }

    rds_sg = {
      name        = "pht-rds-security-group"
      description = "Rancher Database Security Group"
      tags = {
        Name = "db-sg"
      }

      ingress = {
        ssh = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr]
        }
      }
    }
  }
}