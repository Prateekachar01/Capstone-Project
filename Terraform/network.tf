# Creating the VPC

resource "aws_vpc" "vpc" {
  cidr_block       = "10.10.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "VPC-071" #VPC name
  }
}

#Creating the IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "IGW-071" # Internet Gateway name
  }
}

# Find available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

#  Creating 2 Public Subnets in each AZ
resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.10.${1 + count.index}.0/24"  # CIDR calculation
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
tags = {
    Name = "PublicSubnet-071-${count.index + 1}"
     "kubernetes.io/cluster/my-eks-201" = "shared"
    "kubernetes.io/roles/elb"        = "1"
}
}

