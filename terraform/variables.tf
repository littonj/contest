variable "team_id" {}
variable "level_id" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "ssh_key_name" {
  default = "breakathon-key"
}

variable "app1_userdata" {
  default = <<USERDATA
#!/bin/bash
touch /root/finished
USERDATA

}

variable "cache1_userdata" {
  default = <<USERDATA
#!/bin/bash
touch /root/finished
USERDATA

}

variable "db1_userdata" {
  default = <<USERDATA
#!/bin/bash
touch /root/finished
USERDATA

}

variable "frontend1_userdata" {
  default = <<USERDATA
#!/bin/bash
touch /root/finished
USERDATA

}

variable "jumphost1_userdata" {
  default = <<USERDATA
#!/bin/bash
touch /root/finished
USERDATA

}
