


 data "aws_availability_zones" "available_azs" {
 }

 resource "aws_vpc" "devops_sandbox_vpc" {
 
   cidr_block 	= var.vpc_cidr

   tags  = merge(var.common_tags, { Name        = "${var.common_tags["Project"]}-${var.env}-VPC"})
 }

 resource "aws_internet_gateway" "devops_igw" {

   vpc_id 	= aws_vpc.devops_sandbox_vpc.id

   tags  = merge(var.common_tags, { Name        = "${var.common_tags["Project"]}-${var.env}-IGW"})
 }

 resource "aws_subnet" "devops_public_subnets" {
   
   count	   	   = length(var.public_subnet_cidrs)
   vpc_id        	   = aws_vpc.devops_sandbox_vpc.id
   cidr_block	    	   = element(var.public_subnet_cidrs, count.index)
   availability_zone	   = data.aws_availability_zones.available_azs.names[count.index]
   map_public_ip_on_launch = true     #### attaching the public ip addresses

   tags  = merge(var.common_tags, { Name        = "${var.common_tags["Project"]}-${var.env}-Public-Subnet-${count.index + 1}"})
 } 

 resource "aws_route_table" "devops_public_rt" {
 
   vpc_id                  = aws_vpc.devops_sandbox_vpc.id
   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.devops_igw.id 
   }

   tags  = merge(var.common_tags, { Name        = "${var.common_tags["Project"]}-${var.env}-Route-Public-Subnet"})
 }
 
 resource "aws_route_table_association" "public_routes" {

   count		= length(aws_subnet.devops_public_subnets[*].id)
   route_table_id	= aws_route_table.devops_public_rt.id
   subnet_id 		= element(aws_subnet.devops_public_subnets[*].id, count.index)
 }

#------- NAT Gateways with Elastic IPs ------------------------------------------------------------

 resource "aws_eip" "nat_ip" {
 
   count	 = length(var.private_subnet_cidrs) 
   vpc		 = true

   tags  = merge(var.common_tags, { Name        = "${var.common_tags["Project"]}-${var.env}-Elastic-IP-${count.index + 1}"})

 } 

 resource "aws_nat_gateway" "nat_gw" {

   count         = length(var.private_subnet_cidrs)
   allocation_id = aws_eip.nat_ip[count.index].id
   subnet_id 	 = element(aws_subnet.devops_public_subnets[*].id, count.index)

   tags  = merge(var.common_tags, { Name        = "${var.common_tags["Project"]}-${var.env}-NAT-GW-${count.index + 1}"})

 }

#------- Private Subnets and Routing ------------------------------------------------------------

 resource "aws_subnet" "devops_private_subnets" {

   count                   = length(var.private_subnet_cidrs)
   vpc_id 		   = aws_vpc.devops_sandbox_vpc.id
   cidr_block              = element(var.private_subnet_cidrs, count.index)
   availability_zone 	   = data.aws_availability_zones.available_azs.names[count.index]

   tags  = merge(var.common_tags, { Name        = "${var.common_tags["Project"]}-${var.env}-Private-Subnet-${count.index + 1}"})
 }

 resource "aws_route_table" "devops_private_rt" {

   count                   = length(var.private_subnet_cidrs) 
   vpc_id                  = aws_vpc.devops_sandbox_vpc.id
   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_nat_gateway.nat_gw[count.index].id
   }

   tags  = merge(var.common_tags, { Name        = "${var.common_tags["Project"]}-${var.env}-Route-Private-Subnet-${count.index + 1}"})
 }

 resource "aws_route_table_association" "private_routes" {

   count                   = length(aws_subnet.devops_private_subnets[*].id)
   route_table_id	   = aws_route_table.devops_private_rt[count.index].id
   subnet_id	           = element(aws_subnet.devops_private_subnets[*].id, count.index) 
 }
