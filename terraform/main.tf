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
    # Update the package list and install OpenJDK 11
    sudo apt update
    sudo apt install -y openjdk-11-jdk
    java -version

    # Install Jetty server
    sudo apt install -y jetty9

    # Configure Jetty to start on boot
    sudo systemctl enable jetty9

    # Start Jetty server
    sudo systemctl start jetty9

    # Configure firewall to allow traffic on Jetty's default port (8080)
    sudo ufw allow 8080

    # Verify Jetty installation
    curl http://localhost:8080 || echo "Jetty installation failed."

  EOF

  provisioner "local-exec" {
    command = "echo 'EC2 instance created and Jetty server configured'"
  }
}

output "instance_public_ip" {
  value = aws_instance.app_instance.public_ip
}
