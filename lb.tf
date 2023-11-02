# resource "aws_lb" "alb" {
#   name               = "web-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.allow_http.id]
#   subnets            = [aws_subnet.pub_subnet1.id,aws_subnet.pub_subnet2.id]

#   enable_deletion_protection = true

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.id
#     prefix  = "test-lb"
#     enabled = true
#   }

#   tags = {
#     Environment = "dev"
#   }
# }