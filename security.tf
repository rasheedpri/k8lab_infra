resource "aws_security_group" "k8nodes" {
  name        = "k8nodes_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "SSH from Jenkins Master"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["172.16.0.0/26"]
  }

  tags = {
    Name = "Allow inbound traffic"
  }
}