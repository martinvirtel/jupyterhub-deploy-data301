# Create a new instance of the latest Ubuntu 14.04 
provider "aws" {
    region = "${var.region}"
}

data "aws_ami" "ubuntu_ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["*-trusty-14.04-amd64-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}


resource "aws_key_pair" "jupyter_key" {
  key_name = "jupyter-key"
  public_key = "${file("${var.keyfile}.pub")}"
}


resource "aws_security_group" "https_ssh" {
  name = "allow_https_ssh"
  description = "Allow ssh and http"


  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 443 
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_eip" "jupyter_ip" {
  instance                  = "${aws_instance.jupyter.id}"
}

resource "aws_instance" "jupyter" {
    ami = "${data.aws_ami.ubuntu_ami.id}"
    instance_type = "${var.instance_type}"
    key_name = "${aws_key_pair.jupyter_key.key_name}"
    tags {
        Name = "jupyter notebook server"
    }
    security_groups = [ "${aws_security_group.https_ssh.name}" ]
}

