
 output "web_loadbalancer_url" {
  
   value = aws_elb.web-devops-elb.dns_name
 }
