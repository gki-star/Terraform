
 resource "aws_security_group" "my_webserver_dsg" {

    name 	= "Dynamic Security Group"
    description = "My DevOps Dynamic Security Group"
  
    dynamic "ingress" {
      for_each = ["80", "443", "8080"]
     
     content {
      from_port 	  = ingress.value
      to_port		    = ingress.value
      protocol 		  = "tcp"
      cidr_blocks 	= ["0.0.0.0/0"]
      }
    } 

    ingress {
      from_port    = 22
      to_port      = 22
      protocol     = "tcp"
      cidr_blocks  = ["10.10.0.0/16"]
    }

    egress {
      from_port 	  = 0
      to_port 	   	= 0
      protocol   		= "-1"
      cidr_blocks  = ["0.0.0.0/0"]
    }

    tags          = {
      Name         = "devops-eu-1-client2-dsg"
      Owner        = "Gregory.Kirzhner@vodafone.com"
    }
 }

