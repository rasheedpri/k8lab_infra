
# eni for jenkins ec2

resource "aws_network_interface" "jenkins" {
  subnet_id = aws_subnet.priv_subnet1.id

  tags = {
    Name = "${var.Env}_jen_agent"
    Env  = var.Env
    Role = "jenkins"
  }
}

# security group attachment for jenkins eni

resource "aws_network_interface_sg_attachment" "jenkins" {
  security_group_id    = aws_security_group.management.id
  network_interface_id = aws_network_interface.jenkins.id
}


# eni for k8master ec2

resource "aws_network_interface" "k8master" {
  subnet_id = aws_subnet.priv_subnet1.id

  tags = {
    Name = "${var.Env}_k8master"
    Env  = var.Env
    Role = "k8master"
  }

}

# security group attachment for k8master

resource "aws_network_interface_sg_attachment" "k8master" {
  security_group_id    = aws_security_group.management.id
  network_interface_id = aws_network_interface.k8master.id
}

# eni for k8worker nodes on AZ a

resource "aws_network_interface" "k8workers_az_a" {
  count     = 1
  subnet_id = aws_subnet.priv_subnet1.id

  tags = {
    Name = "${var.Env}_k8worker${count.index + 1}"
    Env  = var.Env
    Role = "k8worker"
  }
}

# eni for k8worker nodes on AZ b

resource "aws_network_interface" "k8workers_az_b" {
  count     = 1
  subnet_id = aws_subnet.priv_subnet2.id

  tags = {
    Name = "${var.Env}_k8worker${count.index + 1}"
    Env  = var.Env
    Role = "k8worker"
  }
}


# security group attachment for k8worker nodes on AZ a

resource "aws_network_interface_sg_attachment" "k8workers_az_a" {
  count                = 1
  security_group_id    = aws_security_group.management.id
  network_interface_id = aws_network_interface.k8workers_az_a[count.index].id
}

# security group attachment for k8worker nodes on AZ b

resource "aws_network_interface_sg_attachment" "k8workers_az_b" {
  count                = 1
  security_group_id    = aws_security_group.management.id
  network_interface_id = aws_network_interface.k8workers_az_b[count.index].id
}


# ec2 instace for jenkis agent

resource "aws_instance" "jenkins" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.medium"
  key_name      = "lab-key"


  network_interface {
    network_interface_id = aws_network_interface.jenkins.id
    device_index         = 0
  }

  tags = {
    Name = "${var.Env}_jen_agent"
    Env  = var.Env
    Role = "jenkins"
  }
}


# ec2 instace for k8 master

resource "aws_instance" "k8master" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.medium"
  key_name      = "lab-key"
  iam_instance_profile = "k8_instance_profile"
  

  network_interface {
    network_interface_id = aws_network_interface.k8master.id
    device_index         = 0
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }

  user_data = <<-EOF
  #!/bin/bash
  hostnamectl set-hostname k8master
  EOF

  tags = {
    Name = "${var.Env}_k8master"
    Env  = var.Env
    Role = "k8master"
  }
}

# ec2 instace for k8 worker nodes in AZ a

resource "aws_instance" "k8workers_az_a" {
  count         = 1
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "lab-key"
  iam_instance_profile = "k8_instance_profile"

  network_interface {
    network_interface_id = aws_network_interface.k8workers_az_a[count.index].id
    device_index         = 0
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 15
    delete_on_termination = true
  }

  user_data = <<-EOF
  #!/bin/bash
  hostnamectl set-hostname "k8worker${count.index+1}"
  EOF

  tags = {
    Name = "${var.Env}_k8worker${count.index + 1}"
    Env  = var.Env
    Role = "k8worker"
  }
}


# ec2 instace for k8 worker nodes in AZ b

resource "aws_instance" "k8workers_az_b" {
  count         = 1
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "lab-key"
  iam_instance_profile = "k8_instance_profile"

  network_interface {
    network_interface_id = aws_network_interface.k8workers_az_b[count.index].id
    device_index         = 0
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 15
    delete_on_termination = true
  }

  user_data = <<-EOF
  #!/bin/bash
  hostnamectl set-hostname "k8worker${count.index+1}"
  EOF

  tags = {
    Name = "${var.Env}_k8worker${count.index + 1}"
    Env  = var.Env
    Role = "k8worker"
  }
}

# query eni for k8worker nodes in AZ a to get private ip
data "aws_network_interface" "k8workers_az_a" {
  count = 1
  id    = aws_network_interface.k8workers_az_a[count.index].id
}

# query eni for k8worker nodes in AZ b to get private ip
data "aws_network_interface" "k8workers_az_b" {
  count = 1
  id    = aws_network_interface.k8workers_az_b[count.index].id
}

# query eni for k8master to get private ip
data "aws_network_interface" "k8master" {
  id = aws_network_interface.k8master.id
}

# query eni for jenkis to get private ip
data "aws_network_interface" "jenkins" {
  id = aws_network_interface.jenkins.id
}
