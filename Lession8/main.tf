

  resource "aws_instance" "my_server_web" {
  
    ami 		   = "ami-058e6df85cfc7760b"
    instance_type 	   = "t2.micro"

    vpc_security_group_ids = [aws_security_group.my_webserver_sg.id]

    tags = {
      Name  = "myWEB-devops-eu1-client2"
      Owner = "Gregory.Kirzhner@vodafone.com"
    }
    
    depends_on = [aws_instance.my_server_db, aws_instance.my_server_app]
  }

  resource "aws_instance" "my_server_app" {

    ami                    = "ami-058e6df85cfc7760b"
    instance_type 	   = "t2.micro"

    vpc_security_group_ids = [aws_security_group.my_webserver_sg.id]

    tags = {
      Name  = "myAPP-devops-eu1-client2"
      Owner = "Gregory.Kirzhner@vodafone.com"
    }
   
    depends_on = [aws_instance.my_server_db]
  }


  resource "aws_instance" "my_server_db" {

    ami                    = "ami-058e6df85cfc7760b"
    instance_type          = "t2.micro"

    vpc_security_group_ids = [aws_security_group.my_webserver_sg.id]

    tags = {
      Name  = "myDB-devops-eu1-client2"
      Owner = "Gregory.Kirzhner@vodafone.com"
    }
  }

  resource "aws_security_group" "my_webserver_sg" {

    name = "My Security Group"

    dynamic "ingress" {

      for_each = ["80", "443", "22"]
      content {
        from_port   = ingress.value
        to_port     = ingress.value
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
    
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]

    }
    
    tags  = {
      Name  = "my-devops-eu1-sg"
      Owner = "Gregory.Kirzhner@vodafone.com"
    }
  }
