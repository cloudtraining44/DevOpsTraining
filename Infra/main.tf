 provider "aws" {
  region = "us-east-1"
#  access_key = var.access_key
#  secret_key = var.secret_access_key
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["main"]
  }
}

data "aws_subnet" "public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["public_subnet"] # insert value here
  }
}

data "aws_subnet" "private_subnet" {
  filter {
    name   = "tag:Name"
    values = ["private_subnet"] # insert value here
  }
}

locals {
  subnet_ids = toset([
    data.aws_subnet.public_subnet.id,
    data.aws_subnet.private_subnet.id,
  ])
}

 resource "aws_instance" "demo-instance" {
  for_each               = local.subnet_ids
  ami                    = "ami-0889a44b331db0194"
  instance_type          = "t2.micro"
  key_name               = "demokp"
  vpc_security_group_ids = [aws_security_group.web-sg-01.id]
  user_data              = "${file("userdata_web.sh")}"
#  subnet_id              = data.aws_subnet.public_subnet.id
  subnet_id              = each.key
  tags = {
    Name  = "Server - ${each.key}"
    Owner = "Terraform"
  }
#["${(var.iqr_environment == "dev" ? "admin-role" : "read-role")}"]

}

#Security Group Resource to open port 80 
resource "aws_security_group" "web-sg-01" {
  name        = "Web-SG-01"
  description = "Web-SG-01"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description      = "Port 80 from Everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  #  ipv6_cidr_blocks = ["::/0"]
  }

    ingress {
    description      = "ssh from Everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  #  ipv6_cidr_blocks = ["::/0"]
  }

    ingress {
    description      = "Port 443 from Everywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  #  ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  # ipv6_cidr_blocks = ["::/0"]
  }
}
