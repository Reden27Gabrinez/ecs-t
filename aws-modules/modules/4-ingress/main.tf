data "aws_acm_certificate" "https" {
  count  = var.https.enable ? 1 : 0
  domain = var.https.alb_certificate_name
  types  = ["AMAZON_ISSUED", "IMPORTED"]
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}

# CREATE LOAD BALANCER
resource "aws_lb" "this" {
  name               = "${var.load_balancer_name}-alb"
  internal           = var.alb_deploy_internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = data.aws_subnets.public.ids
    tags = {
    Terraform   = true
    Application = var.load_balancer_name
    Part_Of     = "Ingress Module"
  }
}

# REDIRECT HTTP TO HTTPS
resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

## THROW INTERNAL SERVER ERROR WHEN PORT 80 WAS EXPOSED
  dynamic "default_action" {
    for_each = var.https.enable ? [] : [1]
    content {
      type = "fixed-response"
      fixed_response {
        content_type = "text/plain"
        message_body = ""
        status_code  = "503"
      }
    }

## REDIRECT TO HTTPS WHEN HTTPS IS ENABLED
  }
  dynamic "default_action" {
    for_each = var.https.enable ? [1] : []
    content {
      type = "redirect"
      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }
}

# CREATE HTTPS LISTENER
resource "aws_lb_listener" "https" {
  count             = var.https.enable ? 1 : 0
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.https[0].arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = ""
      status_code  = "503"
    }
  }
}

# Security Group
resource "aws_security_group" "lb" {
  name   = "${var.load_balancer_name}-lb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  dynamic "egress" {
    for_each = var.alb_security_group.egress_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = [data.aws_vpc.selected.cidr_block]
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Terraform   = true
    Application = var.load_balancer_name
    Part_Of     = "Ingress Module"
  }
}

