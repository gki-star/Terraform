 provider "aws" {

   region = "eu-west-3"
 }


 variable "vpc_cidr" {

   default      = "10.0.0.0/16"
 }

 variable "env" {
  
   default	 = "SandBox"
 }

 variable "public_subnet_cidrs" {
 
   default = [
     "10.0.1.0/24", 
     "10.0.2.0/24",
   ]
   type    = list
 }


###  store the terraform.tfstate file remote on S3 Bucket
 
 terraform {
 
   backend "s3" {
     bucket 	= "aws-devops-gki"
     key  	= "sandbox-devops-terraform/state/network/terraform.tfstate"
     region	= "eu-central-1"    ### the region from S3 Bucket
   }

 }


 data "aws_availability_zones" "available_azs" {
 }

 resource "aws_vpc" "devops_sandbox_vpc" {
 
   cidr_block 	= var.vpc_cidr
   
   tags = {
     Name  = "DevOps-${var.env}-VPC"
   }
 }

 resource "aws_internet_gateway" "devops_igw" {

   vpc_id 	= aws_vpc.devops_sandbox_vpc.id
 
   tags = {
     Name	 = "DevOps-${var.env}-IGW"
     Owner       = "Gregory.Kirzhner@vodafone.com"
   }
 }

 resource "aws_subnet" "devops-public-subnets" {
   
   count	   	   = length(var.public_subnet_cidrs)
   vpc_id        	   = aws_vpc.devops_sandbox_vpc.id
   cidr_block	    	   = element(var.public_subnet_cidrs, count.index)
   availability_zone	   = data.aws_availability_zones.available_azs.names[count.index]
   map_public_ip_on_launch = true     #### attaching the public ip addresses

   tags = {
     Name	 = "${var.env}-public-subnet-${count.index+1}"
     Owner	 = "Gregory.Kirzhner@vodafone.com" 
   }
 } 

 resource "aws_route_table" "devops_public_rt" {
 
   vpc_id                  = aws_vpc.devops_sandbox_vpc.id
   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.devops_igw.id 
   }

   tags = {
     Name        = "DevOps-${var.env}-Route-Public-Subnets"
     Owner       = "Gregory.Kirzhner@vodafone.com"
   }
 }
 
 resource "aws_route_table_association" "public_routes" {

   count		= length(aws_subnet.devops-public-subnets[*].id)
   route_table_id	= aws_route_table.devops_public_rt.id
   subnet_id 		= element(aws_subnet.devops-public-subnets[*].id, count.index)
 }

 output "nw_devops_vpc_id" {
   
   value = aws_vpc.devops_sandbox_vpc.id
 }

 output "nw_vpc_id_cidr" {
 
   value = aws_vpc.devops_sandbox_vpc.cidr_block
 }

 output "nw_devops_public_subnet_ids" {
 
   value = aws_subnet.devops-public-subnets[*].id	
 }
 
