
resource "aws_instance" "example" {
  ami                    = var.ami
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = var.user_data_base64
}

resource "aws_security_group" "instance" {
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

output "public_ip" {
  value = aws_instance.example.public_ip
}
