
  resource "aws_lb" "lb" {
  name               = "k8-cluster-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.pub_subnet.id]
  security_groups = [aws_security_group.management.id]


  tags = {
    Environment = "dev"
  }
} 


resource "aws_lb_target_group" "nginx" {
  name     = "tf-example-lb-tg"
  port     = 32524
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}



resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }
}




