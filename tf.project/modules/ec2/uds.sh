#!/bin/bash

# Update package lists
sudo apt update -y
sudo apt upgrade -y

# Install Apache2
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2

# Install OpenJDK 21 JRE
sudo apt install openjdk-21-jre -y
sudo apt update

# Install Jenkins
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins


# Install Docker
sudo apt install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

docker --version

echo "Starting Docker version $(docker --version)" >> /var/log/ud.log
echo "Starting Jenkins status $(systemctl status jenkins)" >> /var/log/ud.log

# Install Git
sudo apt install git -y
# Sync S3 bucket to /var/www/html
aws s3 sync s3://tf-pjkt-13/ /var/www/html/ --region ap-south-1

# Append hostname to index.html
hostname >> /var/www/html/index.html
