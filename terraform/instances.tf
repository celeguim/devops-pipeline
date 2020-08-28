resource "aws_instance" "webserver" {
  count         = 1
  ami           = "ami-0323c3dd2da7fb37d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = "terraform.key"
  vpc_security_group_ids      = [aws_security_group.webserver_security_group.id]
  associate_public_ip_address = true

  user_data =<<EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
  EOF

  tags = {
    Name = "webserver"
  }
}

resource "aws_instance" "dbserver" {
  count         = 1
  ami           = "ami-0323c3dd2da7fb37d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet.id
  key_name      = "terraform.key"
  vpc_security_group_ids = [aws_security_group.dbserver_security_group.id]

  user_data =<<EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y mariadb-server
    sudo systemctl start mariadb-server
    sudo systemctl enable mariadb-server
  EOF

  tags = {
    Name = "dbserver"
  }
}

