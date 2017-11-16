resource "aws_security_group" "caches" {
  description = "AcmeCorp-team_${var.team_id}-level_${var.level_id}"
  vpc_id      = "${aws_vpc.acmevpc.id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "TCP"
    security_groups = ["${aws_security_group.jumphosts.id}"]
  }

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "TCP"
    security_groups = ["${aws_security_group.apps.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "cache" {
  owners = ["self"]
  most_recent = true
  filter {
    name   = "name"
    values = ["breakathon-cache*"]
  }
}

resource "aws_instance" "cache1" {
  ami                         = "${data.aws_ami.cache.id}"
  instance_type               = "t2.nano"
  associate_public_ip_address = "false"
  subnet_id                   = "${aws_subnet.private.id}"
  vpc_security_group_ids      = ["${aws_security_group.caches.id}"]
  key_name                    = "${var.ssh_key_name}"
  user_data                   = "${var.cache1_userdata}"

  tags {
    Name = "cache1-team_${var.team_id}-level_${var.level_id}"
  }
}

resource "aws_route53_record" "cache1" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "cache1.acmecorp.internal"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.cache1.private_ip}"]
}
