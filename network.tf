# create vpc

resource "aws_vpc" "vpc" {
  cidr_block = "172.16.1.0/24"

}

# create subnet

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.16.1.0/26"

  tags   = {
    env  = "dev"
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

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

