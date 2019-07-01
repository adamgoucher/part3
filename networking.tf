resource "aws_vpc" "browser_tests" {
  cidr_block = "10.0.0.0/16"

  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "false"
  enable_classiclink = "false"
  enable_classiclink_dns_support = "false"
  assign_generated_ipv6_cidr_block = "false"

  tags = {
  	Name = "browser tests"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.browser_tests.id}"
  cidr_block = "10.0.0.0/24"

  map_public_ip_on_launch = "false"

  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = "${aws_vpc.browser_tests.id}"
  cidr_block = "10.0.1.0/24"

  map_public_ip_on_launch = "false"

  tags = {
    Name = "private"
  }
}

resource "aws_eip" "browser_tests-nat" {
  vpc      = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.browser_tests-nat.id}"
  subnet_id     = "${aws_subnet.public.id}"

  tags = {
    Name = "nat"
  }
}

resource "aws_route_table" "nat" {
  vpc_id = "${aws_vpc.browser_tests.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat.id}"
  }

  tags = {
    Name = "nat"
  }
}

