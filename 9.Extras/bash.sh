#!/bin/bash

sudo yum install git -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
. ~/.nvm/nvm.sh
nvm install node
npm install -g gatsby-cli
gatsby new my-hello-world-starter https://github.com/gatsbyjs/gatsby-starter-hello-world
cd my-hello-world-starter/
npm install

sudo yum update
sudo yum install -y amazon-linux-extras
sudo  amazon-linux-extras | grep php
sudo amazon-linux-extras enable php7.3
sudo yum install -y php php7.3-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,int$
sudo yum install -y https://dev.mysql.com/get/mysql80-com/get/mysql80-community-release-el7-3.noarch.rpm
sudo yum -y install php-mysqlnd php-pdo -y
sudo yum -y install php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-soap curl curl$
sudo yum install -y mysql-community-server
sudo systemctl start mysqld
sudo systemctl enable mysqld
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
