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
  default = "ami-0affd4508a5d2481b"
}

variable "vpcid" {
  default = "vpc-0f95cf674a2263ee9"
}

variable "subnets" {
  default = "subnet-0c20f2b065f8f4f5c"
}

variable "inst_type" {
  default = "t3.micro"
}
