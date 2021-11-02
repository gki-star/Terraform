 variable "vpc_cidr" {

   default      = "10.0.0.0/16"
 }

 variable "env" {

   default       = "SandBox"
 }

 variable "public_subnet_cidrs" {

   default = [
     "10.0.1.0/24",
     "10.0.2.0/24"
   ]
   type    = list
 }

 variable "private_subnet_cidrs" {

   default = [
     "10.0.11.0/24",
     "10.0.22.0/24"
   ]
   type    = list
 }

 variable "common_tags" {

   type          = map
   description   = "Common Tags to apply to all resources"
   default       = {
     Owner       = "Gregory.Kirzhner@vodafone.com"
     Project	 = "DevOps"
   }
 }
