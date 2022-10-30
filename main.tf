provider "aws" {
   region = "us-east-1"
   profile = "aws_cred"
   }
      
resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"

  tags = {
    Name = "FirstEC2Instnace"
  }
}
