resource "aws_vpc" "dev-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "my-vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_subnet" "public_subnet_az1" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_az1"
  }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true


  tags = {
    Name = "public_subnet_az2"
  }
}

resource "aws_subnet" "priv_subnet_az1" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "priv_subnet_az1"
  }
}

resource "aws_subnet" "priv_subnet_az2" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "priv_subnet_az2"
  }
}

resource "aws_eip" "ngw-eip1" {
  domain = "vpc"
}

resource "aws_eip" "ngw-eip2" {
  domain = "vpc"
}

resource "aws_nat_gateway" "dev-ngw-1" {
  allocation_id = aws_eip.ngw-eip1.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags = {
    Name = "dev-ngw-1"
  }

  depends_on = [aws_internet_gateway.dev-igw]
}

resource "aws_nat_gateway" "dev-ngw-2" {
  allocation_id = aws_eip.ngw-eip2.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags = {
    Name = "dev-ngw-2"
  }

  depends_on = [aws_internet_gateway.dev-igw]
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "priv-rt1" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.dev-ngw-1.id
  }

  tags = {
    Name = "priv-rt-1"
  }
}

resource "aws_route_table" "priv-rt2" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.dev-ngw-2.id
  }

  tags = {
    Name = "priv-rt-2"
  }
}

resource "aws_route_table_association" "pub-sub1-rt-ass" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "pub-sub2-rt-ass" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "priv-sub1-rt-ass" {
  subnet_id      = aws_subnet.priv_subnet_az1.id
  route_table_id = aws_route_table.priv-rt1.id
}

resource "aws_route_table_association" "priv-sub2-rt-ass" {
  subnet_id      = aws_subnet.priv_subnet_az2.id
  route_table_id = aws_route_table.priv-rt2.id
}











