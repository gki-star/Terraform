

 output "webServer_instance_id" {
  
   value = aws_instance.my_WebServer.id
 }


 output "webserver_public_ip_address" {
 
   value = aws_eip.webserver_static_ip.public_ip
 }

 output "webserver_sg_id" {
 
  value = aws_security_group.my_webserver_sg.id
 }

 output "webserver_sg_arn" {

  value	      = aws_security_group.my_webserver_sg.arn
  description = "This is SecurityGroup ARN"
 }
