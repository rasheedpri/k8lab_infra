# create vpc

resource "aws_vpc" "vpc" {
  cidr_block = "172.16.1.0/24"
  region     = "us-east-1"

}

# create subnet

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.16.1.0/26"

  tags   = {
    env  = "dev"
  }
}

