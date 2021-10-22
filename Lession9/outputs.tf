
 output "data_aws_availability_zones" {

   value = data.aws_availability_zones.aws_azs.names
 }


 output "data_aws_caller_identity" {

   value = data.aws_caller_identity.current_identity.account_id
 }

 output "data_aws_region_name" {
 
   value = data.aws_region.curent_region.name
 }

 output "data_aws_region_description" {

   value = data.aws_region.curent_region.description
 }

 output "data_aws_vpcs" {
 
   value = data.aws_vpcs.few_vpcs.ids
 }

 output "data_aws_my_vpc" {
 
   value = data.aws_vpc.my_vpc.id
 }

 output "data_aws_my_vpc_cidr_block" {

   value = data.aws_vpc.my_vpc.cidr_block
 }
