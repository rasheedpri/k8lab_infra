
  resource "aws_lb" "elb" {
  name               = "k8cluster-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.priv_subnet.id]
  security_groups = [aws_security_group.management.id]
  ip_address_type = "ipv4"

  tags = {
    Environment = "dev"
  }
} 


# resource "aws_lb_target_group" "k8worker" {
#   name     = "k8workers"
#   target_type = "instance"
#   port     = 32577
#   protocol = "TCP"
#   vpc_id   = aws_vpc.vpc.id
# }



# resource "aws_lb_listener" "webapp" {
#   load_balancer_arn = aws_lb.elb.arn
#   port              = "80"
#   protocol          = "TCP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.k8worker.arn
#   }
# }


resource "aws_lb_target_group_attachment" "test" {
  count = 2
  target_group_arn = aws_lb_target_group.k8worker.arn
  target_id        = aws_instance.k8worker[count.index].id
  port             = 32577
}


