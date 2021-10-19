
 resource "aws_instance" "myLinux" {
  
    count         = 1
    ami 	  = "ami-058e6df85cfc7760b"
    instance_type = "t2.micro"

    tags          = {
      Name 	  = "devops-eu-1-client2"
      Owner 	  = "Gregory.Kirzhner@vodafone.com"
      AutoTurnOFF = "YES"
      StopTime 	  = "1700"
    }
 } 
