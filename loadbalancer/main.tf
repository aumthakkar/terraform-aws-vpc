# --- loadbalancer/main.tf ---

resource "aws_lb" "pht_lb" {
  name = "pht-lb"

  security_groups = [var.public_sg]
  subnets         = var.public_subnets

  idle_timeout = 300
}

resource "aws_lb_target_group" "pht_lb_tg" {
  name = "pht-lb-${substr(uuid(), 0, 3)}"

  vpc_id = var.vpc_id

  port     = var.tg_port     # 8000 here
  protocol = var.tg_protocol # "HTTP"

  health_check {
    healthy_threshold   = var.tg_healthy_threshold   # 2
    unhealthy_threshold = var.tg_unhealthy_threshold # 2
    interval            = var.tg_interval            # 5 
    timeout             = var.tg_timeout             # 30 
  }

  lifecycle {
    ignore_changes        = [name] # As due to uuid() used in name, a new tg will be created always
    create_before_destroy = true   # So that the LB listener has somewhere to go to during a destroy of tg say in case of tg_port change
  }
}

resource "aws_lb_listener" "pht_lb_listener" {
  load_balancer_arn = aws_lb.pht_lb.arn

  port     = var.lb_port     # 80
  protocol = var.lb_protocol # "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pht_lb_tg.arn
  }
}