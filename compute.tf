# eni for ec2

resource "aws_network_interface" "eni" {
  count       = 4
  subnet_id   = aws_subnet.subnet.id

    tags = {
      env = "dev"
    }
}

# ec2 instaces

resource "aws_instance" "ec2" {
  count         = 4
  ami           = "ami-0a0c8eebcdd6dcbd0"
  instance_type = "t2.micro"
  key_name      = "lab-key"

  network_interface {
    network_interface_id = aws_network_interface.eni[count.index].id
    device_index         = 0
  }

    tags = {
      name = "${var.tag[count.index]}"
      env = "dev"
    }
}

