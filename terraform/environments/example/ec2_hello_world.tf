resource "aws_instance" "example_hello_world" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = base64encode(<<EOF
#!/bin/bash
echo "Hello, World!" > /var/www/html/index.html
nohup python -m SimpleHTTPServer 8080 &
EOF
  )
}

resource "aws_security_group" "example_hello_world_sg" {
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

output "public_ip" {
  value = "${aws_instance.example.public_ip}:8080"
}
