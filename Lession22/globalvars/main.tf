
 provider "aws" {
   
   region = "eu-west-3"
 }

 terraform {

   backend "s3" {

     bucket = "aws-devops-gki"
     key    = "globalvars/terraform.tfstate"
     region = "eu-central-1"
   }
 }

 output "company_name" {

   value = "The ABC Co."
 }

 output "owner" {

   value = "DevOps Eng"
 }

