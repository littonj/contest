resource "aws_security_group" "jumphosts" {
  description = "AcmeCorp-team_${var.team_id}-level_${var.level_id}"
  vpc_id      = "${aws_vpc.acmevpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "jumphost" {
  owners = ["self"]
  most_recent = true
  filter {
    name   = "name"
    values = ["breakathon-jumphost*"]
  }
}

resource "aws_instance" "jumphost1" {
  ami                         = "${data.aws_ami.jumphost.id}"
  instance_type               = "t2.nano"
  associate_public_ip_address = "true"
  subnet_id                   = "${aws_subnet.public.id}"
  vpc_security_group_ids      = ["${aws_security_group.jumphosts.id}"]
  key_name                    = "${var.ssh_key_name}"
  user_data                   = "${var.jumphost1_userdata}"

  tags {
    Name = "jumphost1-team_${var.team_id}-level_${var.level_id}"
  }
}
