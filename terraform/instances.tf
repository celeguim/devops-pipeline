resource "aws_instance" "jenkins" {
  ami = "ami-02354e95b39ca8dec"
  instance_type = "t2.micro"
  key_name = "terraform.key"
  vpc_security_group_ids = [aws_security_group.ingress-all-jenkins.id]
  associate_public_ip_address = true

  user_data = <<EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y java-1.8.0-openjdk
    sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
    sudo rpm --import http://pkg.jenkins-ci.org/redhat-stable/jenkins-ci.org.key
    sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
    sudo yum update -y
    sudo yum install jenkins -y
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    sudo su
    mkdir -p /var/lib/jenkins/.ssh
    chown -R jenkins:jenkins /var/lib/jenkins/.ssh
    cd /var/lib/jenkins/.ssh
    ssh-keyscan -H "${aws_instance.staging.private_ip}" >>/var/lib/jenkins/.ssh/known_hosts
    chown jenkins:jenkins known_hosts
    chmod 600 *
  EOF

  tags = {
    Name = "Jenkins"
  }
}

resource "aws_instance" "staging" {
  ami = "ami-02354e95b39ca8dec"
  instance_type = "t2.micro"
  key_name = "terraform.key"
  vpc_security_group_ids = [
    aws_security_group.ingress-all-jenkins.id]
  associate_public_ip_address = true

  user_data = <<EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y docker java-1.8.0-openjdk
    sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
    sudo rpm --import http://pkg.jenkins-ci.org/redhat-stable/jenkins-ci.org.key
    sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
    sudo yum update -y
    sudo yum install jenkins -y
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    sudo useradd jenkins-staging
    sudo mkdir -p /home/jenkins-staging/.ssh/
    sudo chown -R jenkins-staging:jenkins-staging /home/jenkins-staging/.ssh
    sudo su - jenkins-staging
    ssh-keygen -t rsa -N "" -f /home/jenkins-staging/.ssh/id_rsa
    cd /home/jenkins-staging/.ssh
    cat id_rsa.pub > authorized_keys
    chmod 600 *
    chown -R jenkins-staging:jenkins-staging /home/jenkins-staging/.ssh
  EOF

  tags = {
    Name = "Staging"
  }
}

output "Jenkins_Instance" {
  value = map("private_ip", aws_instance.jenkins.private_ip, "public_ip", aws_instance.jenkins.public_ip)
}

output "Staging_Instance" {
  value = map("private_ip", aws_instance.staging.private_ip, "public_ip", aws_instance.staging.public_ip)
}
