provider "aws" {
  access_key = var.AWS_ACCESS_KEY 
  secret_key = var.AWS_SECRET_ACCESS_KEY 
  region     = "us-east-1"
}

resource "aws_instance" "Reverse-Proxy" {
  instance_type          = "t2.micro"
  ami                    = "ami-08d4ac5b634553e16"
  key_name               = "Llave"
  user_data              = filebase64("${path.module}/scripts/docker.sh")
  vpc_security_group_ids = [aws_security_group.WebSG.id]
}

resource "aws_security_group" "WebSG" {
  name = "sg_reglas_firewall_proyecto_final"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SG HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SG HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SG SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SG All Trafic Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}
# Salida de la IP Publica
output "public_ip" {
  value = join(",", aws_instance.Reverse-Proxy.*.public_ip)
}