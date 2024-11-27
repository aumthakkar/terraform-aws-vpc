
resource "random_integer" "randint" {
  min = 1
  max = 99
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_shuffle" "az" {
  input = data.aws_availability_zones.available.names

  result_count = 20
}

resource "aws_vpc" "pht_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "pht-vpc-${random_integer.randint.result}"
  }
}

resource "aws_subnet" "pht_public_subnet" {
  count = var.public_sn_count

  vpc_id = aws_vpc.pht_vpc.id

  cidr_block        = var.public_cidr[count.index]
  availability_zone = random_shuffle.az.result[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "pht-public-subnet-${count.index + 1}"
  }

}

resource "aws_route_table_association" "pht_public_rt_association" {
  count = var.public_sn_count

  route_table_id = aws_route_table.pht_public_route_table.id
  subnet_id      = aws_subnet.pht_public_subnet.*.id[count.index]

}

resource "aws_subnet" "pht_private_subnet" {
  count = var.private_sn_count

  vpc_id = aws_vpc.pht_vpc.id

  cidr_block        = var.private_cidr[count.index]
  availability_zone = random_shuffle.az.result[count.index]

  map_public_ip_on_launch = false

  tags = {
    Name = "pht-private-subnet-${count.index + 1}"
  }
}

resource "aws_security_group" "pht_sg" {
  for_each = var.security_groups

  name        = each.value.name
  description = each.value.description
  tags        = each.value.tags

  vpc_id = aws_vpc.pht_vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.open]

  }

}

resource "aws_internet_gateway" "pht_igw" {
  vpc_id = aws_vpc.pht_vpc.id

  tags = {
    Name = "pht-internet-gateway"
  }
}

resource "aws_route_table" "pht_public_route_table" {
  vpc_id = aws_vpc.pht_vpc.id

  tags = {
    Name = "pht-public-route-table"
  }
}

resource "aws_route" "pht_public_route" {
  route_table_id = aws_route_table.pht_public_route_table.id

  destination_cidr_block = var.open
  gateway_id             = aws_internet_gateway.pht_igw.id

}


resource "aws_default_route_table" "pht_default_private_route_table" {
  default_route_table_id = aws_vpc.pht_vpc.default_route_table_id

  tags = {
    Name = "pht-default-private-route-table"
  }
}

resource "aws_db_subnet_group" "pht_db_subnet_group" {
  count = var.db_subnet_group ? 1 : 0

  name        = "pht-rds-db-subnet-group"
  description = "subnet-group for the rds instance"

  subnet_ids = aws_subnet.pht_private_subnet.*.id

  tags = {
    Name = "pht-rds-db-subnet-group"
  }
}
