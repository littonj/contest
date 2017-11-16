resource "aws_vpc_dhcp_options" "dhcp" {
  domain_name = "acmecorp.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags {
    Name = "AcmeCorp DHCP options"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id = "${aws_vpc.acmevpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dhcp.id}"
}

resource "aws_route53_zone" "main" {
  name = "acmecorp.internal"
  vpc_id = "${aws_vpc.acmevpc.id}"
  comment = "AcmeCorp DNS Services"
}
