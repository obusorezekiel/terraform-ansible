resource "aws_lb" "web-lb" {
    name = "web-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb-sg.id]
    subnets = [aws_subnet.public_subnet_az1.id, aws_subnet.public_subnet_az2.id]

    tags = {
       Name = "web-alb"
    }
}

resource "aws_lb_target_group" "web-tg" {
    name = "web-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.dev-vpc.id

    health_check {
      interval = 60
      path     = "/"
      port     = 80
      timeout  = 45
        protocol = "HTTP"
        matcher  = "200,202"
    }
}

resource "aws_lb_target_group_attachment" "web-tg-attach1" {
  target_group_arn = aws_lb_target_group.web-tg.arn
  target_id        = aws_instance.web_instance_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web-tg-attach2" {
  target_group_arn = aws_lb_target_group.web-tg.arn
  target_id        = aws_instance.web_instance_2.id
  port             = 80
}

resource "aws_lb_listener" "web-alb-listener" {
    load_balancer_arn = aws_lb.web-lb.arn
    port = "80"
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.web-tg.arn
    }
}
