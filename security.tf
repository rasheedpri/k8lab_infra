# security group to allow for management traffic

resource "aws_security_group" "management" {
  name        = "management_sg"
  description = "allow inbound ssh"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "SSH from Jenkins Master"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/24"]
  }


  tags = {
    Name = "allow inbound ssh"
  }
}

# security group to allow k8cluster inbound

resource "aws_security_group" "k8cluster" {
  name        = "k8cluster_inbound"
  description = "allow ingress to k8cluster"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "nginx from alb"
    from_port   = 31975
    to_port     = 31975
    protocol    = "tcp"
    security_groups      = [aws_security_group.alb.id]
  }

  ingress {
    description = "allow ssh from jenkins_master"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/24"]
  }


  tags = {
    Name = "Allow inbound  web traffic"
  }
  depends_on = [ aws.aws_security_group.alb ]
}

# security group to allow appolcation load balancer inbound

resource "aws_security_group" "alb" {
  name        = "http_inbound_sg"
  description = "Allow inbound http traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "allow http from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 31975
    to_port          = 31975
    protocol         = "tcp"
    security_groups      = [aws_security_group.k8cluster.id]
  }

  tags = {
    Name = "Allow inbound  http traffic"
  }
}
