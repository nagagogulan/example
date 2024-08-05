provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Update this to your preferred AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = "your-key-name"

  tags = {
    Name = "WebServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}
