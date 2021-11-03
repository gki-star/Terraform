
 resource "aws_instance" "imported_web_server" {
  
    ami 	  	 = "ami-089b5384aac360007"
    instance_type 	 = "t2.micro"
    iam_instance_profile = "AmazonEC2RoleforSSM"

    tags = {
      "AutoTurnOFF" = "Yes"
      "Name"        = "vfde-sandbox-devops-eu-central1-master"
      "Owner"       = "Gregory.Kirzhner@vodafone.com"
      "StopTime"    = "1700"  
    }
 }  
