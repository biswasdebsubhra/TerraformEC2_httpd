terraform {
  required_version = ">= 0.11.0"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "org"

    workspaces {
      prefix = "Terraform-"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "Debsg" {
 name        = "Debsg"
 description = "http:8080 and ssh access."
 vpc_id      = "${var.vpcid}"


 # HTTP:8080 access from anywhere
 ingress{
  from_port = "${var.server_port}"
  to_port = "${var.server_port}"
  protocol ="tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

 # ssh access from anywhere
 ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }

 # Setting up the outbound rules
 egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
 tags {
    Name = "CLDTRNF-Debsg"
  }

}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "deb-terraform-up-and-running-states"
  acl    = "public"
  bucket = "terraform-up-and-running-state"
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
   rule {
     apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
      }
    }
  }
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "deb-terraform-up-and-running-states"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}

#resource "aws_eip" "default" {
#  instance = "${aws_instance.webserver.id}"
#  vpc      = true
#}

resource "aws_instance" "webserver"{
 count = "1"
 subnet_id = "${var.subnets}"
 ami = "${var.ami}"
 associate_public_ip_address = "true"
 instance_type = "${var.inst_type}"
 key_name = "${var.key_name}"
 vpc_security_group_ids = ["${aws_security_group.Debsg.id}"]
 ebs_block_device {
    device_name = "/dev/sda1"
    #volume_size = 5
    volume_type = "gp2"
    delete_on_termination = true
  }

user_data = "${file("install_httpd.sh")}"

tags = {
 Name = "CLDTRNF-Deb-WebServer"
 }

#user_data = <<EOF
# #!/bin/bash
# yum update -y
# yum install httpd -y
# echo "<h1>Welcome to DevOps Team Terraform Deployed WebServer</h1>" > /var/www/html/index.html
# systemctl restart httpd
# systemctl enable httpd
# EOF

}
