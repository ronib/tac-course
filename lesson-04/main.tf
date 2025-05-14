terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.50"
    }
  }
  required_version = ">= 1.4.0"
}

provider "aws" {
  region = "us-east-2"
}

// building vm on aws,
resource "aws_instance" "lesson_04" {
  ami           = "ami-0c7c4e3c6b4941f0f" // region east
  instance_type = "t2.micro"              // free tier
  vpc_security_group_ids = [
    aws_security_group.sg_ssh.id, // below
    aws_security_group.sg_https.id
  ]

  tags = {
    Name = "Lesson-04-VM-SG"
  }
}


resource "aws_security_group" "sg_ssh" { // security group for ssh
  ingress {                              // incoming traffic
    cidr_blocks = ["0.0.0.0/0"]          // allow all IPs all networks
    protocol    = "tcp"
    from_port   = 22 // default port ssh, you can connect to this machine with ssh, frfom all networks
    to_port     = 22
  }

  egress { // outgoing traffic
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
}

resource "aws_security_group" "sg_https" { // different name
  ingress {
    cidr_blocks = ["192.168.0.0/16"] // in bound, it's only this network
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"] // out bound, connect to all networks
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
}