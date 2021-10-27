
locals {
  full_project_name = "${var.common_tags["Environment"]}-text"
  region 	    = data.aws_region.current.description
  list_of_azs 	    = join(", ", data.aws_availability_zones.available_azs.names)
  location 	    = "In ${local.region} there are AZ: ${local.list_of_azs}"
}

data "aws_availability_zones" "available_azs" {
}

data "aws_region" "current" {
}

resource "aws_eip" "webserver_static_ip" {


   tags         = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Server IP" }, { PO = local.full_project_name }, { Location = local.location } )

 }
