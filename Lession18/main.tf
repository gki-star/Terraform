 variable "aws_users" {
   
   description   = "List of IAM Users to create"
   default	 = ["Tolstoy", "Gogol", "Dostoevskij", "Akhmatova", "Kuprin", "Chekhov"]
 }

 resource "aws_iam_user" "user" {
 
   name	 	 = "Puschkin"
 }

 resource "aws_iam_user" "users" {
 
   count	 = length(var.aws_users)
   name 	 = element(var.aws_users, count.index)
 }


 resource "aws_instance" "WebServers" {
  
   count 	 = 3 
   ami		 = "ami-058e6df85cfc7760b"
   instance_type = "t2.micro"
 
   tags = {
     name 	 = "Web-Server-${count.index +1}"
   }

 }


 output "created_iam_users_all" {

   value	 = aws_iam_user.users
 }

 output "created_iam_users_ids" {

   value         = aws_iam_user.users[*].id
 }

 output "created_iam_users_custom_list" {

   value  = [
     for i in aws_iam_user.users:
     "Username: ${i.name} has ARN: ${i.arn}"
   ]
 }

 output "created_aim_users_custom_map" {
 
   value  = {
     for i in aws_iam_user.users:
     i.unique_id => i.id
   }
 }

 output "custom_if_length" {
 
   value = [
     for i in aws_iam_user.users:
     i.name
     if length(i.name <= 7)
   ]
 }

 output "server_all" {
  
   value  = {
     for i in aws_instance.WebServers:
     i.id => i.public_ip
   } 
 }
 
