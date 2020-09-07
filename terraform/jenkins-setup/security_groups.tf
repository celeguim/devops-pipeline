data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "ingress-all-jenkins" {
  name = "allow-all-sg"
  vpc_id = data.aws_vpc.default.id

  # ssh connection
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  # http server
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }

  # jenkins server
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    self = true
  }

  # we will need to update and install packages from internet
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    to_port = 0
    protocol = -1
  }

}
