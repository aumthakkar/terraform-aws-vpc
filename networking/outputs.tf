# --- networking/outputs.tf ---

output "vpc_id" {
  value = aws_vpc.pht_vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.pht_db_subnet_group.*.id # .id attribute gives the subnet group name
}

output "db_security_groups" {
  value = aws_security_group.pht_sg["rds_sg"].id
}

output "public_security_groups" {
  value = aws_security_group.pht_sg["public_sg"].id
}

output "public_subnets" {
  value = [for subnet in aws_subnet.pht_public_subnets : subnet.id]
  # Can also use this: value = aws_subnet.pht_public_subnets.*.id
}