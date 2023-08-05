resource "aws_instance" "example_hello_world" {
  ami                    = local.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example_hello_world_sg.id]

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
echo Hello World! | tee index.html
python3 -m http.server 8080 --directory $(pwd) &
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

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

output "public_ip" {
  value = "${aws_instance.example_hello_world.public_ip}:8080"
}
