resource "aws_lb" "nlb" {
  name               = "tsar-nlb"
  load_balancer_type = "network"
  security_groups    = [aws_security_group.nlb.id]

  subnets = [
    aws_subnet.subnet_1.id,
    aws_subnet.subnet_2.id
  ]

  internal                   = false
  enable_deletion_protection = false
  ip_address_type            = "ipv4"
}


resource "aws_lb_listener" "nlb_for_minecraft" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 25565
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_for_minecraft.arn
  }
}

resource "aws_lb_target_group" "nlb_for_minecraft" {
  name        = "nlb-target-group-for-minecraft"
  port        = 25565
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    protocol = "TCP"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "nlb" {
  name        = "tsar-nlb-security-group"
  description = "tsar application load balancer security group"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "nlb_for_minecraft" {
  from_port         = 25565
  to_port           = 25565
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.nlb.id
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "nlb" {
  ip_protocol       = "-1"
  security_group_id = aws_security_group.nlb.id
  cidr_ipv4         = "0.0.0.0/0"
}
