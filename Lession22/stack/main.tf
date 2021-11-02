
 provider "aws" {
  
   region = "eu-central-1"
 }

 data "terraform_remote_state" "global" {
 
   backend = "s3"
   config {
     bucket = "aws-devops-gki"
     key    = "globalvars/terraform.tfstate"
     region = "eu-central-1" 
   }
 }

 locals {
   
   owner    = data.terraform_remote_state.global.outputs.owner
   company  = data.terraform_remote_state.global.outputs.company_name 
 }

 resource "aws_vpc" "myVPC" {
  
   cidr_block = "10.0.0.0/16"

   tags =  {
     Owner = local.owner
   }
 }
