# ---------------------------
# Subnets, IGW, NAT, Routes
# ---------------------------

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tf-main-igw"
  }
}

# Public Subnets (2)
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-public-${local.azs[count.index]}"
    Tier = "public"
  }
}

# Private Subnets (2)
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 10)
  availability_zone = local.azs[count.index]

  tags = {
    Name = "tf-private-${local.azs[count.index]}"
    Tier = "private"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "tf-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway
# resource "aws_eip" "nat" {
#  domain = "vpc"

# tags = {
#   Name = "tf-nat-eip"
#  }
#}

# resource "aws_nat_gateway" "nat" {
#  allocation_id = aws_eip.nat.id
#  subnet_id     = aws_subnet.public[0].id

#  tags = {
#   Name = "tf-nat-gw"
#  }

#  depends_on = [aws_internet_gateway.igw]

#}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  # No default rout to NAT (cost-saving)
  #route {
  # cidr_block     = "0.0.0.0/0"
  # nat_gateway_id = aws_nat_gateway.nat.id
  #}

  tags = {
    Name = "tf-private-rt"
  }
}

resource "aws_route_table_association" "private_assoc" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

