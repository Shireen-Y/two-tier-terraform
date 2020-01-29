# Set a provider
# Configure the AWS Provider
provider "aws" {
  region  = "eu-west-1"
}

# Create VPC
resource "aws_vpc" "two_tier_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.name} - VPC"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "two_tier_gw" {
  vpc_id = aws_vpc.two_tier_vpc.id
  tags = {
    Name = "${var.name} - igw"
  }
}

# Create public subnet
resource "aws_subnet" "pub_subnet" {
  vpc_id = aws_vpc.two_tier_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "${var.name} - public subnet"
  }
}

# Create route table for public subnet
resource "aws_route_table" "pub_route_table" {
  vpc_id = aws_vpc.two_tier_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.two_tier_gw.id
  }
  tags = {
    Name = "${var.name} - route"
  }
}

# Route table associations for public subnet
resource "aws_route_table_association" "pub_assoc" {
  subnet_id = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.pub_route_table.id
}

# Create private subnet
resource "aws_subnet" "priv_subnet" {
  vpc_id = aws_vpc.two_tier_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "${var.name} - private subnet"
  }
}

# Create route table for private subnet
resource "aws_route_table" "priv_route_table" {
  vpc_id = aws_vpc.two_tier_vpc.id
  tags = {
    Name = "${var.name} - private route"
  }
}

# Route table associations for private subnet
resource "aws_route_table_association" "priv_assoc" {
  subnet_id = aws_subnet.priv_subnet.id
  route_table_id = aws_route_table.priv_route_table.id
}
