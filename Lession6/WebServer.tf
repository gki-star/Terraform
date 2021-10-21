
 resource "aws_eip" "webserver_static_ip" {
   
   instance = aws_instance.my_WebServer.id

 }

 resource "aws_instance" "my_WebServer" {
  
    ami 	  	   = "ami-058e6df85cfc7760b"   #### Amazon linux AMI 
    instance_type 	   = "t2.micro"
    vpc_security_group_ids = ["sg-0f39b4f165e4c11a6", aws_security_group.my_webserver_sg.id]
    user_data 		   = templatefile("user_data.sh.tpl", {
      f_name = "Gregory",
      l_name = "Kirschner",
      names  = ["Green", "Yellow", "Blue", "Red", "White"]
      })

    tags          = {
      Name 	  = "devops-eu-1-client2"
      Owner 	  = "Gregory.Kirzhner@vodafone.com"
      AutoTurnOFF = "YES"
      StopTime 	  = "1700"
    }
    
    lifecycle { 
      # prevent_destroy 	    = true		# destroying will be not working if you make a change on instance
      # ignore_changes 	    = [ami, user_data]	# ignore the changes
      create_before_destroy = true
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

