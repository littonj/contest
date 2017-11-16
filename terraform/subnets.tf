resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.acmevpc.id}"
  cidr_block = "172.28.0.0/24"
  tags {
    Name = "AcmeCorp Public Subnet"
  }

  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}

resource "aws_route_table_association" "public_routing" {
  subnet_id = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.acmevpc.id}"
  cidr_block = "172.28.3.0/24"
  tags {
    Name = "AcmeCorp Private Subnet"
  }

  availability_zone = "${data.aws_availability_zones.available.names[1]}"
}

resource "aws_route_table_association" "private_routing" {
  subnet_id = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.private.id}"
}
