

 resource "null_resource" "command1" {
 
   provisioner 	"local-exec" {

     command 	= "echo Terraform start: $(date) >> log.txt"
   }
 }


 resource "null_resource" "command2" {

   provisioner  "local-exec" {

     command    = "ping -c 5 www.google.de"
   }
 }

 
 resource "null_resource" "command3" {

   provisioner  "local-exec" {

     command     = "print('Hello World!')"
     interpreter = ["python", "-c"]
   }
 }


 resource "null_resource" "command4" {

   provisioner  "local-exec" {

     command     = "echo $NAME1 $NAME2 $NAME3 >> log.txt"
     environment = {
      NAME1 = "Vasya"
      NAME2 = "Petya"
      NAME3 = "Kolya"
     }
   }
 }

 resource "aws_instance" "myserver" {
  
   ami 		 = "ami-058e6df85cfc7760b"
   instance_type = "t2.micro"
   
   provisioner  "local-exec" {
     command = "echo Hello from AWS Instance Creation!" 
   }
 }
 
 resource "null_resource" "command6" {

   provisioner  "local-exec" {

     command    = "echo Terraform End: $(date) >> log.txt"
   }
   depends_on = [null_resource.command1, null_resource.command2, null_resource.command3, null_resource.command4, aws_instance.myserver]
 }
