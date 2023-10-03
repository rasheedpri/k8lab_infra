# eni for ec2

resource "aws_network_interface" "eni" {
  count       = 4
  subnet_id   = aws_subnet.subnet.id

    tags = {
      Name = "${var.ec2_name[count.index]}"
      Env = "dev"
      Role = "${var.ec2_role[count.index]}"
    }
}

# ec2 instaces

resource "aws_instance" "ec2" {
  count         = 4
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "lab-key"

  network_interface {
    network_interface_id = aws_network_interface.eni[count.index].id
    device_index         = 0
  }

    tags = {
      Name = "${var.ec2_name[count.index]}"
      Env = "dev"
      Role = "${var.ec2_role[count.index]}"
    }
}

data "aws_network_interface" "k8worker" {
  filter {
    name = "tag:Role"
    values = ["k8worker"]
  }
}

data "aws_network_interface" "k8master" {
  filter {
    name = "tag:Role"
    values = ["k8_master"]
  }
}
