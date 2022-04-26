#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

yum update -y
yum upgrade
yum install wget git -y
amazon-linux-extras install epel -y && yum update -y
wget -O /etc/yum.repos.d/jenkins.repo \
    http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins java-1.8.0-openjdk-devel -y
systemctl daemon-reload
systemctl start jenkins
systemctl status jenkins
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install terraform

# nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
. ~/.nvm/nvm.sh
nvm install node
#test
node -e "console.log('Running Node.js ' + process.version)"