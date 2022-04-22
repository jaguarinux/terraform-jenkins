# VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block           = "10.0.41.0/24"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    "Name" = "vpc-${var.code_name}"
  }
}
## SUBNETS
# Subnet public 1
resource "aws_subnet" "tf_subnet_public1" {
  depends_on              = [aws_vpc.tf_vpc]
  vpc_id                  = aws_vpc.tf_vpc.id
  availability_zone       = var.az1
  cidr_block              = var.subnet_cidrs_public1
  map_public_ip_on_launch = true
  tags = {
    "Name" = "subnet-public1-${var.code_name}"
  }
}
# Internet gateway
resource "aws_internet_gateway" "tf-igw" {
  depends_on = [aws_vpc.tf_vpc]
  vpc_id     = aws_vpc.tf_vpc.id

  tags = {
    "Name" = "ig-${var.code_name}"
  }
}

################
#route table public
resource "aws_route_table" "rt_public_1" {
  depends_on = [aws_vpc.tf_vpc, aws_internet_gateway.tf-igw]
  vpc_id     = aws_vpc.tf_vpc.id

  route {
    cidr_block = var.cdirAll
    gateway_id = aws_internet_gateway.tf-igw.id
  }

  tags = {
    "Name" = "rtPublic-${var.code_name}"
  }
}
# route table association public
resource "aws_route_table_association" "tf-rtpub" {
  depends_on     = [aws_subnet.tf_subnet_public1, aws_route_table.rt_public_1]
  subnet_id      = aws_subnet.tf_subnet_public1.id
  route_table_id = aws_route_table.rt_public_1.id
}

