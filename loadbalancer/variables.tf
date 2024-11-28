# --- loadbalancer/variables.tf ---

variable "public_sg" {}
variable "public_subnets" {}

# LB target_group variables

variable "vpc_id" {}
variable "tg_port" {}
variable "tg_protocol" {}

variable "tg_healthy_threshold" {}
variable "tg_unhealthy_threshold" {}
variable "tg_interval" {}
variable "tg_timeout" {}

# LB Listener variables

variable "lb_port" {}
variable "lb_protocol" {}
