
 variable "aws_ami_owner" {

   default = ["137112412989"]
   type    = list
 }


 provider "aws" {

   region 		   = "ca-central-1"
   alias		   = "CA"
   
/*
   assume_role {
     role_arn 	  = "arn:aws:iam::1234567890:role/RemoteAdministrators"  ### the owner from another account should provide Role: RemoteAdministrators (role_name is open)
     session_name = "TERRAFORM_SESSION"
   }
*/
 }

 provider "aws" {

   region                  = "us-east-1"
   alias                   = "USA"
 }

 data "aws_ami" "latest_amazon_linux_usa" {
 
   provider		   = aws.USA
   owners		   = var.aws_ami_owner 
   most_recent 		   = true

   filter {
     name 	 = "name"
     values	 = ["amzn2-ami-hvm-*-x86_64-gp2"]
   }
 }

 data "aws_ami" "latest_amazon_linux_ca" {

   provider                = aws.CA
   owners                  = var.aws_ami_owner
   most_recent             = true

   filter {
     name        = "name"
     values      = ["amzn2-ami-hvm-*-x86_64-gp2"]
   }
 }

 data "aws_ami" "latest_amazon_linux_eu" {

   owners                  = var.aws_ami_owner
   most_recent             = true

   filter {
     name        = "name"
     values      = ["amzn2-ami-hvm-*-x86_64-gp2"]
   }
 }


 resource "aws_instance" "WebServer_EU" {

    ami                    =  data.aws_ami.latest_amazon_linux_eu.id  #### Amazon linux AMI
    instance_type          = "t2.micro"

    tags = {
      name 		   = "Default EU Server"
    }
 }


 resource "aws_instance" "WebServer_CA" {
    
    provider		   = aws.CA
    ami                    = data.aws_ami.latest_amazon_linux_ca.id  #### Amazon linux AMI
    instance_type          = "t2.micro"

    tags = {
      name                 = "Default CA Server"
    }
 }

 resource "aws_instance" "WebServer_USA" {

    provider               = aws.USA
    ami                    = data.aws_ami.latest_amazon_linux_usa.id   #### Amazon linux AMI
    instance_type          = "t2.micro"

    tags = {
      name                 = "Default USA Server"
    }
 }

 output "eu_ami" {

   value = aws_instance.WebServer_EU.ami
 }
 
 output "ca_ami" {

   value = aws_instance.WebServer_CA.ami
 }

 output "us_ami" {

   value = aws_instance.WebServer_USA.ami
 }
