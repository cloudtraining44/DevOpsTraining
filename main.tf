

resource "aws_instance" "web" {
    ami = "ami-0889a44b331db0194"
    instance_type = "t2.micro"

    tags = {
      Name  = "web-1"
      Owner = "Terraform"
    }
}

resource "aws_security_group" "web-sg" {
    name = "webSG"
    
    ingress {
    description      = "ssh from Everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  #  ipv6_cidr_blocks = ["::/0"]
  }
}