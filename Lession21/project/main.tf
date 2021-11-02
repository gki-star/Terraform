
 provider "aws" {

    region 	= "eu-west-3"
 }

 module "vpc-dev" {
 
//   source 	        = "../modules/aws_network"  ### for local store of modules
   source = "git@github.com:gki-star/Terraform.git//Lession21/modules/aws_network"  ### for remote store of modules
   env   		= "Train"
   vpc_cidr		= "10.100.0.0/16"
   public_subnet_cidrs  = ["10.100.1.0/24", "10.100.2.0/24"]
   private_subnet_cidrs = ["10.100.11.0/24", "10.100.22.0/24"]
 }
