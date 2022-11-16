resource "local_file" "users"
{
  filename = "/root/config_files/user.txt"
  content = "User details - Anna, Sally, John"
}

resource "aws_instance" "jenkins server"
{
  ami = "amibvgg545465"
  instance_type = "t3.micro"
  tags = {
    Name = "JenkinsServer"
 }
  
 resource "aws_instance" "jenkins server"
{
  ami = var.ami
  instance_type = var.instance_type
  tags = {
    Name = "JenkinsServer"
 }
