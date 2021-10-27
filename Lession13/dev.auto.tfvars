# 
# file to autofill the variables
#
# the files can be named as
#   -  terraform.tfvars
#   -  <name>.auto.tfvars
#


  instance_type 	      = "t2.small"

  allow_ports	              = ["80", "8080"]

  enable_ditailed_monitoring  = "false"
