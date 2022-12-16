resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "vpc_public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.subnets_count)
  availability_zone       = element(var.availability_zone, count.index)
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-sub-${element(var.availability_zone, count.index)}"
  }

}

resource "aws_subnet" "vpc_private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.subnets_count)
  availability_zone = element(var.availability_zone, count.index)
  cidr_block        = "10.0.${count.index + 2}.0/24"

  tags = {
    Name = "pri-sub-${element(var.availability_zone, count.index)}"
  }

}


resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "inernetGW"
  }
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "pub-route-tbl"
  }

}

resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.subnets_count)
  subnet_id      = element(aws_subnet.vpc_public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_eip" "elasticIP" {
  count = length(var.subnets_count)
  vpc   = true

}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.subnets_count)
  allocation_id = element(aws_eip.elasticIP.*.id, count.index)
  subnet_id     = element(aws_subnet.vpc_public_subnet.*.id, count.index)

  tags = {
    Name = "nat-GTW-${count.index}"
  }

}

resource "aws_route_table" "private_route_table" {
  count  = length(var.subnets_count)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = {
    Name = "pri-route-tbl"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.subnets_count)
  subnet_id      = element(aws_subnet.vpc_private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_route_table.*.id, count.index)

}

resource "aws_security_group" "vpc_sg" {
  name        = "vpc_sg"
  description = "Security group for vpc"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "SSH access from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "internet access to anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-sg"
  }

}
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_rsa_key" {
  content  = tls_private_key.key.private_key_pem
  filename = "private_rsa_key"
}

resource "aws_key_pair" "public_rsa_key" {
  key_name   = "public_rsa_key"
  public_key = tls_private_key.key.public_key_openssh
}

resource "aws_instance" "my_app_server" {
  ami                         = var.instance_ami
  instance_type               = var.instance_size
  key_name                    = aws_key_pair.public_rsa_key.key_name
  count                       = length(var.subnets_count)
  subnet_id                   = element(aws_subnet.vpc_public_subnet.*.id, count.index)
  security_groups             = [aws_security_group.vpc_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt install apache2 -y
  sudo systemctl start apache2
  sudo systemctl enable apache2
  sudo apt install git -y
  git clone https://github.com/palakbhawsar98/FirstWebsite.git
  cd /FirstWebsite
  sudo cp index.html /var/www/html/
  EOF

  tags = {
    Name = "my_app_server-${count.index}"
  }

}
