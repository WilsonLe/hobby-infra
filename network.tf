resource "aws_vpc" "wilsonle-hobby-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "wilsonle-hobby-vpc"
  }
}

resource "aws_subnet" "wilsonle-hobby-subnet-1" {
  vpc_id            = aws_vpc.wilsonle-hobby-vpc.id
  cidr_block        = "10.0.0.0/17"
  availability_zone = "${var.region}a"
  tags = {
    Name = "wilsonle-hobby-subnet-1"
  }
}

resource "aws_subnet" "wilsonle-hobby-subnet-2" {
  vpc_id            = aws_vpc.wilsonle-hobby-vpc.id
  cidr_block        = "10.0.128.0/17"
  availability_zone = "${var.region}b"
  tags = {
    Name = "wilsonle-hobby-subnet-2"
  }
}

resource "aws_internet_gateway" "wilsonle-hobby-vpc-gateway" {
  vpc_id = aws_vpc.wilsonle-hobby-vpc.id
  tags = {
    Name = "wilsonle-hobby-vpc-gateway"
  }
}

resource "aws_security_group" "wilsonle-hobby-security-group" {
  name        = "wilsonle-hobby-security-group"
  description = "Allow wilsonle-hobby-security-group ports"
  vpc_id      = aws_vpc.wilsonle-hobby-vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "PostgreSQL from VPC"
    from_port   = var.database-secrets.DATABASE_PORT
    to_port     = var.database-secrets.DATABASE_PORT
    protocol    = "tcp"
    cidr_blocks = [var.my-ip]
    self        = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "wilsonle-hobby-security-group"
  }
}

resource "aws_route_table" "wilsonle-hobby-route-table" {
  vpc_id = aws_vpc.wilsonle-hobby-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wilsonle-hobby-vpc-gateway.id
  }

  tags = {
    Name = "wilsonle-hobby-route-table"
  }
}

resource "aws_route_table_association" "wilsonle-hobby-route-table-assoc-1" {
  subnet_id      = aws_subnet.wilsonle-hobby-subnet-1.id
  route_table_id = aws_route_table.wilsonle-hobby-route-table.id
}

resource "aws_route_table_association" "wilsonle-hobby-route-table-assoc-2" {
  subnet_id      = aws_subnet.wilsonle-hobby-subnet-2.id
  route_table_id = aws_route_table.wilsonle-hobby-route-table.id
}
