# Create a new load balancer
resource "aws_elb" "lb" {
  name               = "k8clusterlb"
  availability_zones = ["us-east-1d", "us-east-1a"]
  security_groups = aws_security_group.management.id

  listener {
    instance_port     = 32524
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:32524/"
    interval            = 30
  }

  instances                   = [aws_instance.k8worker[0],aws_instance.k8worker[1]]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "k8_cluster_lb"
  }
}