resource "aws_security_group" "management" {
  name        = "management_sg"
  description = "Allow inbound management traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "SSH from Jenkins Master"
    from_port   = 0
    to_port     = 65534
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/16"]
  }


  tags = {
    Name = "Allow inbound  management traffic"
  }
}

