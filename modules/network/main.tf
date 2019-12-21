data "aws_availability_zones" "az" {}

resource "aws_vpc" "test" {
  cidr_block       = vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.env}-vps"
  }
}

resource "aws_internet_gateway" "test" {
  vpc_id = aws_vpc.test.id

  tags = {
    Name = "${var.env}-ig"
  }
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.test.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-pub-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "test" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test.id
  }

  tags = {
    Name = "${var.env}-rt"
  }
}

resource "aws_route_table_association" "rt_association" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.test.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}
