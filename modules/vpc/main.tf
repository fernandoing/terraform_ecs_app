resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames= true
  enable_dns_support= true
  tags = merge(
    var.tags, 
    {
      "Name" = "${var.vpc_name}_vpc"
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags, 
    {
      "Name" = "${var.vpc_name}_igw"
    }
  )
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count                   = 3
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = merge(
    var.tags, 
    {
      "Name" = "${var.vpc_name}_public_subnet_${count.index}"
    }
  )
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = 3
  subnet_id      = aws_subnet.public[count.index].id
  #subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" # Route to public internet
    gateway_id = aws_internet_gateway.main.id
  }

  tags = var.tags
}


