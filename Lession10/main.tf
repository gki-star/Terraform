
  data "aws_ami" "latest_ubuntu" {
  
    owners 	= ["099720109477"]
    most_recent = true

    filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
  }


  data "aws_ami" "latest_amz_linux" {

    owners      = ["137112412989"]
    most_recent = true

    filter {
      name   = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
  }


  resource "aws_instance" "my_WebServer" {

    ami                    = data.aws_ami.latest_amz_linux.id   #### Amazon linux AMI
    instance_type          = "t2.micro"

  }
