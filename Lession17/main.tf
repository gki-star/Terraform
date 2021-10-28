
 variable "env" {

   type 	  = string
   default	  = "prod"
 }

 variable "inst_size" {
   
   default = {
     prod 	 = "t3.micro"
     staging	 = "t2.small"
     dev	 = "t2.micro"
   } 
 }

 variable "allow_port_list" {
 
   default = {
     prod 	  = ["80", "443"]
     dev 	  = ["80", "443", "8080", "22"]
   } 
 }
 
 
 resource "aws_instance" "my_server" {

   ami		  = "ami-058e6df85cfc7760b"
   instance_type  = var.env == "dev" ? var.inst_size["dev"] : var.inst_size["prod"]

   tags = {
     envieronment = var.env == "dev" ? "DEV SandBox" : "PROD SandBox"
   }
 }

 resource "aws_instance" "dev_bastion_host" {

  ami            = "ami-058e6df85cfc7760b"
  count 	 = var.env == "dev" ? 1 : 0
  instance_type  = var.env == "dev" ? "t2.micro" : "t3.micro"

  tags = {
    Description  = "Bastion Server for DEV env" 
  }
 } 


 resource "aws_instance" "my_server2" {

  ami            = "ami-058e6df85cfc7760b"
  instance_type  = lookup(var.inst_size, var.env)

  tags = {
    envieronment = var.env == "dev" ? "DEV SandBox" : "PROD SandBox"
  }
 }


 resource "aws_security_group" "my_webserver_dsg" {

    name       		 = "Dynamic Security Group"
    description 	 = "My DevOps Dynamic Security Group"

    dynamic "ingress" {
      for_each = lookup(var.allow_port_list, var.env)

     content {
      from_port           = ingress.value
      to_port             = ingress.value
      protocol            = "tcp"
      cidr_blocks         = ["0.0.0.0/0"]
      }
    }

    egress {
      from_port           = 0
      to_port          	  = 0
      protocol            = "-1"
      cidr_blocks 	  = ["0.0.0.0/0"]
    }

    tags   = {
      Name 	          = "devops-eu-1-client2-dsg"
      Owner         	  = "Gregory.Kirzhner@vodafone.com"
    }
 }
