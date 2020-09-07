resource "aws_instance" "k8s-admin" {
  ami = "ami-06b263d6ceff0b3dd"
  instance_type = "t2.micro"
  key_name = "terraform.key"
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  iam_instance_profile = aws_iam_instance_profile.my_iam_profile.name
  associate_public_ip_address = true

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/Users/celeguim/.aws/terraform.key.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo snap install kubectl --classic",
      "sudo snap install kops",
      "sudo apt install awscli -y"
    ]
  }

  tags = {
    Name = "k8s-admin"
  }
}

output "Jenkins_Instance" {
  value = map("private_ip", aws_instance.k8s-admin.private_ip, "public_ip", aws_instance.k8s-admin.public_ip)
}
