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
  }
}
