# network.tf

resource "aws_vpc" "tf-testing" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "tf-testing"
  }
}

resource "aws_subnet" "public-tf-testing" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.tf-testing.id
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private-tf-testing" {
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.tf-testing.id
  availability_zone = "us-east-1a"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.tf-testing.id
}

resource "aws_route_table" "public-tf-route" {
  vpc_id = aws_vpc.tf-testing.id
}

resource "aws_route_table" "private-tf-route" {
  vpc_id = aws_vpc.tf-testing.id
}

resource "aws_route" "public-tf-route" {
  route_table_id         = aws_route_table.public-tf-route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "private-tf-route" {
  route_table_id         = aws_route_table.private-tf-route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public-tf-route.id
  subnet_id      = aws_subnet.public-tf-testing.id
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.tf-testing.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
