# main.tf

resource "aws_instance" "example" {
  ami                    = "ami-045602374a1982480"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  subnet_id              = aws_subnet.public-tf-testing.id
  key_name = "ansible_key"
  associate_public_ip_address = true
}

output "instance_ip" {
  value = aws_instance.example.public_ip
}
