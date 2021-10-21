#!/bin/bash
yum -y update
yum -y install httpd
myIP = `curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>Webserver IP: $myIP</h2><br>Build by Terraform using External script!" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
