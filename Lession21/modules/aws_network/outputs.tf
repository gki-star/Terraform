 output "nw_devops_vpc_id" {

   value = aws_vpc.devops_sandbox_vpc.id
 }

 output "nw_vpc_id_cidr" {

   value = aws_vpc.devops_sandbox_vpc.cidr_block
 }

 output "nw_devops_public_subnet_ids" {

   value = aws_subnet.devops_public_subnets[*].id
 }
 
 output "nw_devops_private_subnet_ids" {

   value = aws_subnet.devops_private_subnets[*].id
 }
