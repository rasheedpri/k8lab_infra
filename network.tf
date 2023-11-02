# create dev vpc

resource "aws_vpc" "vpc" {
  cidr_block = "172.16.1.0/24"

  tags = {

    Name = "dev_vpc"
    Env  = var.Env
  }

}

# create public subnet

resource "aws_subnet" "pub_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "172.16.1.0/26"

  tags = {

    Name = "dev_subnet"
    Env  = var.Env
  }
}

# create public subnet2

resource "aws_subnet" "pub_subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "172.16.1.128/26"
  availability_zone = "us-east-1a"
  tags = {

    Name = "dev_subnet"
    Env  = var.Env
  }
}

# create private subnet

resource "aws_subnet" "priv_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "172.16.1.64/26"

  tags = {

    Name = "dev_subnet"
    Env  = var.Env
  }
}


# vpc peering


resource "aws_vpc_peering_connection" "peering" {
  vpc_id      = aws_vpc.vpc.id
  peer_vpc_id = "vpc-01b068a477baa5e42"
  auto_accept = true
}

resource "aws_vpc_peering_connection_options" "peering" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id

  # accepter {
  #   allow_remote_vpc_dns_resolution = true
  # }
}


# create igw for dev vpc

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Env = var.Env
  }
}

# # eip for nat gateway

# resource "aws_eip" "nat" {
#   domain = "vpc"
# }

# # nat gateway 

# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.pub_subnet.id

#   tags = {
#     Env = var.Env
#   }
# }


# route table for priv_subnet

resource "aws_route_table" "priv" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "priv_subnet_rt"
  }

  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.nat.id
  # }

  route {
    cidr_block                = "172.16.0.0/25"
    vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  }


}

# route table assosiation dev subnet

resource "aws_route_table_association" "priv" {
  subnet_id      = aws_subnet.priv_subnet.id
  route_table_id = aws_route_table.priv.id
}


# route table for public_subnet

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "public_subnet_rt"
  }



  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


}



# route table assosiation public subnet

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.public.id
}

# route table assosiation public subnet2

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.pub_subnet2.id
  route_table_id = aws_route_table.public.id
}

# add route to route table in management (jenkins) vpc

resource "aws_route" "route" {
  route_table_id            = "rtb-0158457a6faac9304"
  destination_cidr_block    = "172.16.1.64/26"
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

