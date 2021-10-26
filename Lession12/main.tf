
 data "aws_ami" "latest_amzn_linux" {
 
   owners 	= ["amazon"]
   most_recent  = true
   filter {
     name 	= "name"
     values 	= ["amzn2-ami-hvm-*-x86_64-gp2"] 
   
   }
 }



 resource "aws_eip" "webserver_static_ip" {
   
   instance 	= aws_instance.my_WebServer.id

   tags 	= merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Server IP"})	

 }


 resource "aws_instance" "my_WebServer" {
  
    ami 	  	   = data.aws_ami.latest_amzn_linux.id  #### Amazon linux AMI 
    instance_type 	   = var.instance_type
    vpc_security_group_ids = ["sg-0f39b4f165e4c11a6", aws_security_group.my_webserver_sg.id]
    monitoring 		   = var.enable_ditailed_monitoring

    tags   		   = merge(var.common_tags, { Name 	= "web-${var.common_tags["Environment"]}-eu1-server"},  
    		                          	    { AutoTurnOFF = "YES"},  
			                  	    { StopTime    = "1700"}
    
    )

    
 }


 resource "aws_security_group" "my_webserver_sg" {

    name 	= "Webserver Security Group"
    description = "My DevOps Security Group"
  
    dynamic "ingress" {
      for_each = var.allow_ports
      content {
        from_port 	= ingress.value
        to_port		= ingress.value
        protocol 	= "tcp"
        cidr_blocks 	= ["0.0.0.0/0"]
      }
    }

    egress {
      from_port 	= 0
      to_port 		= 0
      protocol 		= "-1"
      cidr_blocks       = ["0.0.0.0/0"]
    }

    tags          	= merge(var.common_tags, { Name  = "devops-eu-1-client2-sg"} )
    

 }
