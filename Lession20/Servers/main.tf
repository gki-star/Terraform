

 provider "aws" {
 
   region = "eu-west-3"
 }


 variable "aws_ami_owner" {

   default = ["137112412989"]
   type    = list
 }


 terraform {
   
   backend "s3" {
     bucket = "aws-devops-gki"
     key    = "sandbox-devops-terraform/state/servers/terraform.tfstate"
     region = "eu-central-1"
   } 
 }



 data "terraform_remote_state" "network" {
   
   backend = "s3"
   config = {
     bucket     = "aws-devops-gki"
     key        = "sandbox-devops-terraform/state/network/terraform.tfstate"
     region     = "eu-central-1"
   }
 }


 data "aws_ami" "latest_amazon_linux" {

   owners                  = var.aws_ami_owner
   most_recent             = true

   filter {
     name        = "name"
     values      = ["amzn2-ami-hvm-*-x86_64-gp2"]
   }
 }


 resource "aws_instance" "devops_webserver" {
 
   ami 	         	  = data.aws_ami.latest_amazon_linux.id
   instance_type	  = "t2.micro"
   vpc_security_group_ids = [aws_security_group.http_webserver_sg.id] 
   subnet_id 		  = data.terraform_remote_state.network.outputs.nw_devops_public_subnet_ids[0]

   tags = {
     Name  = "DevOps SandBox Webserver"
     Owner = "Gregory.Kirzhner@vodafone.com"
   }
 }


 resource "aws_security_group" "http_webserver_sg" {
   name        = "WebServer Security Group"
  
   vpc_id      = data.terraform_remote_state.network.outputs.nw_devops_vpc_id

   ingress {

      from_port        = 80
      to_port          = 80
      protocol 	       = "tcp" 
      cidr_blocks      = ["0.0.0.0/0"]
   }
  

   ingress { 
  
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [data.terraform_remote_state.network.outputs.nw_vpc_id_cidr]
   }
  

   egress { 
  
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  

  tags = {
    Name  = "http-webserver-sg"
    Owner = "Gregory.Kirzhner@Vodafone.com"
  }
}

 output "srv_webserver_sg_id" {

   value = aws_security_group.http_webserver_sg.id
 }

 output "srv_webserver_public_ip" {
 
   value = aws_instance.devops_webserver.public_ip
 }
