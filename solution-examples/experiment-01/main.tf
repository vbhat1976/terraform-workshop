provider "aws" {
  version = "~> 2.0"
  region = "${var.region}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "force_nginx_server" {
  key_name   = "force_nginx_server_key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_security_group" "force_nginx" {
  name        = "force_nginx_firewall"
  description = "Firewall for the force-nginx-server"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx_server" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  key_name = "${aws_key_pair.force_nginx_server.key_name}"

  user_data = <<EOF
#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
  EOF

  security_groups = ["${aws_security_group.force_nginx.name}"]

  tags = {
    Name = "force-nginx-server"
  }
}