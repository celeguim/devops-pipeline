# Webserver Security Group
resource "aws_security_group" "webserver_security_group" {
  vpc_id      = aws_vpc.default.id
  name        = "Webserver Security Group"
  description = "Webserver Security Group"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
  }
  ingress {
    cidr_blocks = ["109.136.74.170/32"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Webserver Security Group"
  }
}

# DB server Security Group
resource "aws_security_group" "dbserver_security_group" {
  vpc_id      = aws_vpc.default.id
  name        = "DB server Security Group"
  description = "DB server Security Group"
  ingress {
    cidr_blocks = ["10.10.1.0/24"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["10.10.1.0/24"]
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB server Security Group"
  }
}

