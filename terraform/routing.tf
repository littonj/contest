data "aws_availability_zones" "available" {}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.acmevpc.id}"
  tags {
    Name = "AcmeCorp Gateway"
  }
}

resource "aws_network_acl" "all" {
  vpc_id = "${aws_vpc.acmevpc.id}"
  egress {
    protocol = "-1"
    rule_no = 2
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }

  ingress {
    protocol = "-1"
    rule_no = 1
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }

  tags {
    Name = "AcmeCorp Network ACL (Open)"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.acmevpc.id}"
  tags {
    Name = "AcmeCorp Routing Table - Public"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.acmevpc.id}"
  tags {
    Name = "AcmeCorp Routing Table - Private"
  }

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.public_nat.id}"
  }
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "public_nat" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.public.id}"
  depends_on = ["aws_internet_gateway.gw"]
}
