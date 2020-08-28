provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile = "default"
}

resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "Public Route Table"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.private_subnet_cidr_block
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Private Subnet"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.public_subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "Public Subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "Internet Gateway"
  }
}

# Associate Public Route to Internet Gateway
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# Associate public subnet to the route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "default" {
  vpc = true
}

resource "aws_nat_gateway" "default" {
  allocation_id = aws_eip.default.id
  subnet_id = aws_subnet.public_subnet.id
  tags = {
    Name = "NAT Gateway"
  }
}

# Associate Private Route to NAT Gateway
resource "aws_route" "nat_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.default.id
}
