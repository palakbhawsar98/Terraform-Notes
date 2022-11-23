variable "ami-name" {
   description = "Name of an AMI"
   type = string
   default = "ami-08c40ec9ead489470"
}

variable "instance-size" {
   description = "Size of an Instance"
   type = string
   default = "t2.micro"
}
