resource "aws_security_group" "management" {
  name        = "management_sg"
  description = "Allow inbound management traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "SSH from Jenkins Master"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "Allow inbound  management traffic"
  }
}


resource "aws_security_group" "worker_inbound" {
  name        = "management_sg"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "web from alb"
    from_port   = 31795
    to_port     = 31795
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from Jenkins Master"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "Allow inbound  web traffic"
  }
}



resource "aws_security_group" "allow_http" {
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
    from_port        = 31795
    to_port          = 31795
    protocol         = "tcp"
    security_groups      = [aws_security_group.worker_inbound.id]
  }

  tags = {
    Name = "Allow inbound  http traffic"
  }
}
