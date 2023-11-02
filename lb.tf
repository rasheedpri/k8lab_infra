resource "aws_lb" "alb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = [aws_subnet.pub_subnet1.id,aws_subnet.pub_subnet2.id]

  tags = {
    Environment = "dev"
  }
}