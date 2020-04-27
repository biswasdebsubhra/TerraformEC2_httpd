#Terraform EC2 and httpd webserver variables

variable "server_port" {
description = "The port the server will use for HTTP requests"
default = 80
}

variable "key_name" {
  default     = "Deb-PCF"
}

# CentOS7 x86_64
variable "ami" {
  default = "ami-*******"
}

variable "vpcid" {
  default = "vpc-*******"
}

variable "subnets" {
  default = "subnet-*******"
}

variable "inst_type" {
  default = "t3.micro"
}
