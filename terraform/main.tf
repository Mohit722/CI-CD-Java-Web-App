provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "app_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "AppInstance"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y openjdk-8-jdk maven ansible
    sudo apt install -y tomcat8
    sudo systemctl start tomcat8
  EOF

  provisioner "local-exec" {
    command = "echo 'EC2 instance created and configured'"
  }
}

output "instance_public_ip" {
  value = aws_instance.app_instance.public_ip
}
