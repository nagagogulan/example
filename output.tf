output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.public.id
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}
