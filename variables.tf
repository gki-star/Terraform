
 variable "instance_type" {

   default	 = "t2.micro"
   type 	 = string

 }

 
 variable "allow_ports" {

   description   = "List of ports to open server"
   type 	 = list
   default 	 = ["80", "443", "8080"]

 }

 
 variable "enable_ditailed_monitoring" {
 
   type 	 = bool
   default 	 = "false"
 }

 
 variable "common_tags" {
 
   type 	 = map
   description   = "Common Tags to apply to all resources"
   default	 = {
     Owner       = "Gregory.Kirzhner@vodafone.com" 
     Environment = "DevOps-SandBox"
   }
 }
