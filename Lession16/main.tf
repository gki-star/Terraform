 variable "env" {

   default = "dev"
 }

 resource "random_string" "rds_passwords" {

   length 	    = 12
   special	    = true
   override_special = "!@#*" 
   keepers = {
     keeper1 = var.env
   }
 }

 resource "aws_ssm_parameter" "rds_passwords" {
 
   name 	= "/prod/mysql"
   description  = "Master password for RDS MySQL"
   type 	= "SecureString"
   value 	= random_string.rds_passwords.result
 }


 data "aws_ssm_parameter" "my_rds_pwd" {

    name 	= "/prod/mysql"

    depends_on  = [aws_ssm_parameter.rds_passwords]

 }


 resource "aws_db_instance" "default" {
 
   identifier 	        = "prod-rds"
   allocated_storage    = 20
   storage_type         = "gp2"
   engine 	        = "mysql"
   engine_version       = "5.7"
   instance_class       = "db.t2.micro"
   name                 = "mySQLDB"
   username             = "Administrator"
   password             = data.aws_ssm_parameter.my_rds_pwd.value
   parameter_group_name = "default.mysql5.7"
   skip_final_snapshot  = true
   apply_immediately 	= true
 }




 output "rds_password" {

   value 	= data.aws_ssm_parameter.my_rds_pwd.value
   sensitive    = true 		# exporting sensitive data that has been intended 
 }


 
