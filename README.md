# Terraform

- **Terraform** is an infrastructure as code tool that lets you build, change, and version cloud and on-prem resources safely and efficiently.

- **Infrastructure as Code** Infrastructure as code (IaC) tools allow you to manage infrastructure with configuration files rather than through a graphical user interface. IaC allows you to build, change, and manage your infrastructure in a safe, consistent, and repeatable way by defining resource configurations that you can version, reuse, and share.

- **Install Terraform** 

##### Ubuntu/Debian
```
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```
##### Centos/RHEL

```
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform
```
- **Check version**
```
terraform version
```

*Terraform configuration files are written in HCL to deploy infrastructure resources, this files have .tf extentiuons*

- **HCL Basics** (HashiCorp Configuration Language)
```
<block> <parameters> {
  key1 = value1
  key2 = value2
}
```
- Example of resource file for provisioning AWS EC@ Instance
```
resource "aws-instance" "webserver" {
     ami = "ami-096544567687980"
     instance_type = 't2.micro"
}     
```
- Create a configuration file with .tf extensions

- This command will check the configuration file and initialize the   working directory containing   the .tf file.
```
terraform init 
```
- This command  will show the actions that carried out by terraform to create     the resource.
```
terraform plan
```
- This command will show the actions and asked user to type yes.
```
terraform apply
```
- This command will show the resources we have created.
```
terraform show
```
- To Update resources, edit the .tf file and run
```
terraform apply
```
- To destroy the infrasytructure
```
terraform destroy 
```
##### Variables in terraform

varibles can be defined in variables .tf file and can be used in configuration files as **var.variable_name**

##### Types of variables
- string ("file")
- bool (true/false)
- number (7)
- any (Default value)


##### How to define variables in variables.tf file using parameter (default, type, and description)
```
variable "filename" {
   deafult = "test"
   type = string
   description = "configuration file namee"
   }
```
##### Define envtronment variables in terraform.tfvars or terraform.tfvars.json

- This command  will show the sysntax used is correct or not
```
terraform validate
```
- This command scans the configuratiion files in the current working directory and formats the code. It is used to improve the readability of files.
```
terraform fmt
```
- This command will list all the providers used in configuration file
```
terraform providers
```
- This command will mirror the provider configuration in new path.
```
terraform providers mirror /<file_path>
```
- This command will print all the output variables in the configuration files
```
terraform output
```
- This command is used to sync the terraform with real-world resources
```
terraform refresh
```
#### Terraform Lifecycle Rule

- This is used in configuration file when you don't want your resources to ve dlete before creation of new resources
```
lifecycle {
   create_before_destroy = true
   }
```
- This is used in configuration file when you don't want your old resources to be deleted
```
lifecycle {
   prevent_destroy = true
   }
```

