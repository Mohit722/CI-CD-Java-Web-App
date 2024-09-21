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
    user_data = <<-EOF
    #!/bin/bash
    # Update and install OpenJDK 11
    sudo apt-get update
    sudo apt-get install -y openjdk-11-jdk
    java -version

    # Create Tomcat user
    sudo useradd -m -d /opt/tomcat -U -s /bin/false tomcat

    # Download and install Tomcat
    cd /tmp
    wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.20/bin/apache-tomcat-10.0.20.tar.gz
    sudo tar xzvf apache-tomcat-10.0.20.tar.gz -C /opt/tomcat --strip-components=1
    sudo chown -R tomcat:tomcat /opt/tomcat/
    sudo chmod -R u+x /opt/tomcat/bin

    # Configure Tomcat users
    sudo bash -c 'cat <<EOT >> /opt/tomcat/conf/tomcat-users.xml
    <role rolename="manager-gui" />
    <user username="manager" password="manager_password" roles="manager-gui" />
    <role rolename="admin-gui" />
    <user username="admin" password="admin_password" roles="manager-gui,admin-gui" />
    EOT'

    # Update Tomcat context.xml for manager and host-manager
    sudo sed -i 's/<Valve className="org.apache.catalina.valves.RemoteAddrValve".*\/>//g' /opt/tomcat/webapps/manager/META-INF/context.xml
    sudo sed -i 's/<Valve className="org.apache.catalina.valves.RemoteAddrValve".*\/>//g' /opt/tomcat/webapps/host-manager/META-INF/context.xml

    # Create systemd service for Tomcat
    sudo bash -c 'cat <<EOT >> /etc/systemd/system/tomcat.service
    [Unit]
    Description=Tomcat
    After=network.target

    [Service]
    Type=forking

    User=tomcat
    Group=tomcat

    Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64"
    Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
    Environment="CATALINA_BASE=/opt/tomcat"
    Environment="CATALINA_HOME=/opt/tomcat"
    Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
    Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

    ExecStart=/opt/tomcat/bin/startup.sh
    ExecStop=/opt/tomcat/bin/shutdown.sh

    RestartSec=10
    Restart=always

    [Install]
    WantedBy=multi-user.target
    EOT'

    # Reload systemd and start Tomcat
    sudo systemctl daemon-reload
    sudo systemctl start tomcat
    sudo systemctl enable tomcat

    # Allow traffic on port 8080
    sudo ufw allow 8080
  EOF


  provisioner "local-exec" {
    command = "echo 'EC2 instance created and configured'"
  }
}

output "instance_public_ip" {
  value = aws_instance.app_instance.public_ip
}
