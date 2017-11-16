resource "aws_security_group" "databases" {
  description = "AcmeCorp-team_${var.team_id}-level_${var.level_id}"
  vpc_id      = "${aws_vpc.acmevpc.id}"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "TCP"
    security_groups = ["${aws_security_group.apps.id}"]
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

data "aws_ami" "db" {
  owners = ["self"]
  most_recent = true
  filter {
    name   = "name"
    values = ["breakathon-db*"]
  }
}

resource "aws_instance" "db1" {
  ami                         = "${data.aws_ami.db.id}"
  instance_type               = "t2.nano"
  associate_public_ip_address = "false"
  subnet_id                   = "${aws_subnet.private.id}"
  vpc_security_group_ids      = ["${aws_security_group.databases.id}"]
  key_name                    = "${var.ssh_key_name}"
  user_data                   = "${var.db1_userdata}"

  tags {
    Name = "db1-team_${var.team_id}-level_${var.level_id}"
  }
}

resource "aws_route53_record" "db1" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "db1.acmecorp.internal"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.db1.private_ip}"]
}
