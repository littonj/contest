resource "aws_security_group" "frontends" {
  description = "AcmeCorp-team_${var.team_id}-level_${var.level_id}"
  vpc_id      = "${aws_vpc.acmevpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "TCP"
    security_groups = ["${aws_security_group.jumphosts.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "frontend" {
  owners = ["self"]
  most_recent = true
  filter {
    name   = "name"
    values = ["breakathon-frontend*"]
  }
}

resource "aws_instance" "frontend1" {
  depends_on                  = ["aws_route53_record.app1"]
  ami                         = "${data.aws_ami.frontend.id}"
  instance_type               = "t2.nano"
  associate_public_ip_address = "true"
  subnet_id                   = "${aws_subnet.public.id}"
  vpc_security_group_ids      = ["${aws_security_group.frontends.id}"]
  key_name                    = "${var.ssh_key_name}"
  user_data                   = "${var.frontend1_userdata}"

  tags {
    Name = "frontend1-team_${var.team_id}-level_${var.level_id}"
  }
}

resource "aws_route53_record" "frontend1" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "frontend1.acmecorp.internal"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.frontend1.private_ip}"]
}
