resource "aws_security_group" "apps" {
  description = "AcmeCorp-team_${var.team_id}-level_${var.level_id}"
  vpc_id      = "${aws_vpc.acmevpc.id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "TCP"
    security_groups = ["${aws_security_group.jumphosts.id}"]
  }

  ingress {
    from_port       = 4567
    to_port         = 4567
    protocol        = "TCP"
    security_groups = ["${aws_security_group.frontends.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "app" {
  owners = ["self"]
  most_recent = true
  filter {
    name   = "name"
    values = ["breakathon-app*"]
  }
}

resource "aws_instance" "app1" {
  depends_on                  = ["aws_route53_record.db1"]
  ami                         = "${data.aws_ami.app.id}"
  instance_type               = "t2.nano"
  associate_public_ip_address = "false"
  subnet_id                   = "${aws_subnet.private.id}"
  vpc_security_group_ids      = ["${aws_security_group.apps.id}"]
  key_name                    = "${var.ssh_key_name}"
  user_data                   = "${var.app1_userdata}"

  tags {
    Name = "app1-team_${var.team_id}-level_${var.level_id}"
  }
}

resource "aws_route53_record" "app1" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "app1.acmecorp.internal"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.app1.private_ip}"]
}
