

 data "aws_availability_zones" "aws_azs"{
 }

 data "aws_caller_identity" "current_identity" {
 }

 data "aws_region" "curent_region" {
 }

 data "aws_vpcs" "few_vpcs" {
 }

 data "aws_vpc" "my_vpc" {
 
   tags = {
     Name = "vfde-sandbox-eucentral1-main"
   }
 }

 
 resource "aws_subnet" "devops_subnet_1" {
 
   vpc_id 	     = data.aws_vpc.my_vpc.id

   availability_zone = data.aws_availability_zones.aws_azs.names[0]
   cidr_block 	     = data.aws_vpc.my_vpc.cidr_block
   
   tags = {
     Name    = "Subnet-1 in ${data.aws_availability_zones.aws_azs.names[0]}"
     Account = "Subnet in Account ${data.aws_caller_identity.current_identity.account_id}"
     Region  = data.aws_region.curent_region.description
   }
 }
