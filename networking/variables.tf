# --- networking/variables.tf ---

variable "vpc_cidr" {
  type = string
}
variable "public_sn_count" {}
variable "public_cidr" {}
variable "security_groups" {}

variable "private_sn_count" {}
variable "private_cidr" {}
variable "open" {}

variable "db_subnet_group" {
  type = bool
}

