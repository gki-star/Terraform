
 resource "aws_instance" "my_WebServer" {
  
    count        	   = 1
    ami 	  	   = "ami-058e6df85cfc7760b"   #### Amazon linux AMI 
    instance_type 	   = "t2.micro"
    vpc_security_group_ids = ["sg-0f39b4f165e4c11a6", aws_security_group.my_webserver_sg.id]
    user_data 		   = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
echo "<h2>Webserver IP</h2><br>Build by Terraform!" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF

    tags          = {
      Name 	  = "devops-eu-1-client2"
      Owner 	  = "Gregory.Kirzhner@vodafone.com"
      AutoTurnOFF = "YES"
      StopTime 	  = "1700"
    }
 }

 resource "aws_security_group" "my_webserver_sg" {

    name 	= "Webserver Security Group"
    description = "My DevOps Security Group"
  
    ingress {
      from_port 	= 80
      to_port		= 80
      protocol 		= "tcp"
      cidr_blocks 	= ["0.0.0.0/0"]
    }

    ingress {
      from_port         = 443
      to_port           = 443
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
    }

    egress {
      from_port 	= 0
      to_port 		= 0
      protocol 		= "-1"
      cidr_blocks       = ["0.0.0.0/0"]
    }

    tags          = {
      Name        = "devops-eu-1-client2-sg"
      Owner       = "Gregory.Kirzhner@vodafone.com"
    }
 }
