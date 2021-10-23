

 data "aws_availability_zones" "aws_allowed_azs" {
 }

 data "aws_ami" "amz_linux_latest" {
  
   owners	 = ["137112412989"]
   most_recent   = true
  
   filter {
     name   = "name"
     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
   }

 }

 resource "aws_security_group" "devops-dsg" {

   name	    = "http-https-connection-sg"
   
   dynamic ingress {
   
     for_each = ["80", "443"]
     content {
       from_port   = ingress.value
       to_port 	   = ingress.value
       protocol    = "tcp"
       cidr_blocks = ["10.10.0.0/16"]
     }
   }
   
   egress {
     
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
   }

   tags = {

     owner = "Gregory.Kirzhner@vodafone.com"
   }
 }


 resource "aws_launch_configuration" "devops-web-lc" {
   name 	   = "web-devops-sandbox-eu1-ha-lc"
   image_id 	   = data.aws_ami.amz_linux_latest.id
   instance_type   = "t2.micro"

   security_groups = [aws_security_group.devops-dsg.id]

   user_data 	   = file("user_data.sh")	

   lifecycle {
     create_before_destroy = true
   }
 }


 resource "aws_autoscaling_group" "devops-web-asg" {

   name       	 	   = "web-devops-sandbox-eu1-ha-asg"
   launch_configuration    = aws_launch_configuration.devops-web-lc.name
   min_size 		   = 2
   max_size 		   = 2
   min_elb_capacity 	   = 2
   health_check_type       = "ELB"
   vpc_zone_identifier 	   = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
   load_balancers 	   = [aws_elb.web-devops-elb.name]

   lifecycle {
     create_before_destroy = true
   }

   dynamic "tag" {
    for_each = {
      Name  		   = "Webserver in ASG"   
      Owner 	  	   = "Gregory.Kirzhner@vodafone.com"
      AutoTurnOFF	   = "YES"
    }
     content{
      key                  = tag.key
      value                = tag.value
      propagate_at_launch  = true
     }
   }
/*
   tags = [
    {
      key		  = "Name"
      value		  = "WebSerever-in-ASG"
      propagate_at_launch = true
    },
    {
      key                 = "Owner"
      value               = "Gregory.Kirzhner@vodafone.com"
      propagate_at_launch = true
    }
   ]
*/
 }

 resource "aws_elb" "web-devops-elb" {
   
   name 		  = "WEB-DevOps-EU1-HA-ELB"
   availability_zones 	  = [data.aws_availability_zones.aws_allowed_azs.names[0], data.aws_availability_zones.aws_allowed_azs.names[1]]
   security_groups 	  = [aws_security_group.devops-dsg.id]
   listener {
     lb_port 	          = 80
     lb_protocol 	  = "http"
     instance_port 	  = 80
     instance_protocol 	  = "http"
   }
   health_check {
     healthy_threshold 	  = 2
     unhealthy_threshold  = 2
     timeout 		  = 3
     target 		  = "HTTP:80/"
     interval 		  = 10
   }

   tags = {
     Name  = "WEB-DevOps-eu1-HA-ELB"
     Owner = "Gregory.Kirzhner@vodafone.com"
   }
 }

 resource "aws_default_subnet" "default_az1" {
   
   availability_zone = data.aws_availability_zones.aws_allowed_azs.names[0]
 }


 resource "aws_default_subnet" "default_az2" {

   availability_zone = data.aws_availability_zones.aws_allowed_azs.names[1]
 }


