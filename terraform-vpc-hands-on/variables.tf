variable "subnets_count" {
   type =  list(string)
   default = ["subnet1","subnet2"]
}

variable "region" {
   default = "us-east-1"
}

variable "availability_zone" {
   type =  list(string)
   default = ["us-east-1a","us-east-1b"]
}

variable "instance_ami" {
    type = string
   default = "ami-0574da719dca65348"
}

variable "instance_size" {
    type = string
    default = "t2.micro"
}
