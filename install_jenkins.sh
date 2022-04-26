#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

yum update -y
yum upgrade

# git
yum install wget git -y

# jenkins
amazon-linux-extras install epel -y && yum update -y
wget -O /etc/yum.repos.d/jenkins.repo \
    http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins java-11-openjdk-devel -y
systemctl daemon-reload
systemctl start jenkins
systemctl status jenkins

# terraform
wget https://releases.hashicorp.com/terraform/1.1.9/terraform_1.1.9_linux_amd64.zip
unzip ./terraform_1.1.9_linux_amd64.zip -d /usr/local/bin
terraform -v

# nodejs
echo "Get the install script"
export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
echo "Install node"
nvm install node
#test node
node -e "console.log('Running Node.js ' + process.version)"