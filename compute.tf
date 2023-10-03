# eni for k8master ec2

resource "aws_network_interface" "k8master" {
  subnet_id   = aws_subnet.subnet.id

    tags = {
      Name = "${var.Env}_k8master"
      Env = var.Env
      Role = "k8master"
    }
}

# eni for k8worker nodes

resource "aws_network_interface" "k8worker" {
  count = 2
  subnet_id   = aws_subnet.subnet.id

    tags = {
      Name = "${var.Env}_k8worker${count.index+1}"
      Env = var.Env
      Role = "k8worker"
    }
}

# ec2 instace for k8 master

resource "aws_instance" "k8master" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "lab-key"

  network_interface {
    network_interface_id = aws_network_interface.k8master.id
    device_index         = 0
  }

    tags = {
      Name = "${var.Env}_k8master"
      Env = var.Env
      Role = "k8master"
    }
}

# ec2 instace for k8 worker nodes

resource "aws_instance" "k8worker" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "lab-key"

  network_interface {
    network_interface_id = aws_network_interface.k8master.id
    device_index         = 0
  }

    tags = {
      Name = "${var.Env}_k8worker${count.index+1}"
      Env = var.Env
      Role = "k8worker"
    }
}

data "aws_network_interface" "k8worker" {
  count = 2
  id = aws_network_interface.k8worker.id
}

data "aws_network_interface" "k8master" {
  id = aws_network_interface.k8master.id
}

