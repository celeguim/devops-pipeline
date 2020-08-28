resource "aws_instance" "jenkins" {
  count           = 2
  ami             = "ami-02354e95b39ca8dec"
  instance_type   = "t2.micro"
  key_name        = "terraform.key"
  vpc_security_group_ids      = [aws_security_group.ingress-all-jenkins.id]
  associate_public_ip_address = true

  user_data =<<EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd docker java-1.8.0-openjdk
    echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
    sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
    sudo rpm --import http://pkg.jenkins-ci.org/redhat-stable/jenkins-ci.org.key
    sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
    sudo yum update -y
    sudo yum install jenkins -y
    sudo systemctl start httpd
    sudo systemctl enable httpd
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
  EOF

  tags = {
    Name = "Jenkins"
  }
}
