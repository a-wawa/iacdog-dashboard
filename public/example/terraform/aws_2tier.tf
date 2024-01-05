# provider 설정
provider "aws" {
  access_key = "your_access_key"
  secret_key = "your_secret_key"
  region  = "ap-south-1"
}

# key 이름
variable "key_name" {
  default = "ec2Key"
}

# aws keypair
resource "aws_key_pair" "key_pair" {
#   depends_on = [tls_private_key.private_key]
  key_name   = var.key_name
#   public_key = tls_private_key.private_key.public_key_openssh
}

# vpc 설정
resource "aws_vpc" "vpc" {
  cidr_block       = "192.168.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}

# public subnet 설정
resource "aws_subnet" "public_subnet" {
  depends_on = [
    aws_vpc.vpc,
  ]

  vpc_id     = aws_vpc.vpc.id
  cidr_block = "192.168.0.0/24"

  tags = {
    Name = "public-subnet"
  }

  map_public_ip_on_launch = true
}

# private subnet 설정
resource "aws_subnet" "private_subnet" {
  depends_on = [
    aws_vpc.vpc,
  ]

  vpc_id     = aws_vpc.vpc.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "private-subnet"
  }
}

# internet gateway 설정
resource "aws_internet_gateway" "internet_gateway" {
  depends_on = [
    aws_vpc.vpc,
  ]

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "internet-gateway"
  }
}

# internet gateway와의 route table 설정
resource "aws_route_table" "IG_route_table" {
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.internet_gateway,
  ]

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "IG-route-table"
  }
}

# public subnet 과 route table 연결 설정
resource "aws_route_table_association" "associate_routetable_to_public_subnet" {
  depends_on = [
    aws_subnet.public_subnet,
    aws_route_table.IG_route_table,
  ]
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.IG_route_table.id
}

# NAT gateway를 위한 elastic ip 생성
resource "aws_eip" "elastic_ip" {
  vpc      = true
}

# NAT gateway 설정
resource "aws_nat_gateway" "nat_gateway" {
  depends_on = [
    aws_subnet.public_subnet,
    aws_eip.elastic_ip,
  ]
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "nat-gateway"
  }
}

# NAT gateway와의 route table 설정
resource "aws_route_table" "NAT_route_table" {
  depends_on = [
    aws_vpc.vpc,
    aws_nat_gateway.nat_gateway,
  ]

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "NAT-route-table"
  }
}

# private subnet 과 route table 연결 설정
resource "aws_route_table_association" "associate_routetable_to_private_subnet" {
  depends_on = [
    aws_subnet.private_subnet,
    aws_route_table.NAT_route_table,
  ]
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.NAT_route_table.id
}

# bastion host의 security group 설정
resource "aws_security_group" "sg_bastion_host" {
  depends_on = [
    aws_vpc.vpc,
  ]
  name        = "sg bastion host"
  description = "bastion host security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# wordpress security group
resource "aws_security_group" "sg_wordpress" {
  depends_on = [
    aws_vpc.vpc,
  ]

  name        = "sg wordpress"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "allow TCP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.sg_bastion_host.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# mysql security group
resource "aws_security_group" "sg_mysql" {
  depends_on = [
    aws_vpc.vpc,
  ]
  name        = "sg mysql"
  description = "Allow mysql inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "allow TCP"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.sg_wordpress.id]
  }

  ingress {
    description = "allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.sg_bastion_host.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# bastion host ec2 instance
resource "aws_instance" "bastion_host" {
  depends_on = [
    aws_security_group.sg_bastion_host,
  ]
  ami = "ami-0732b62d310b80e97"
  instance_type = "t2.micro"
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.sg_bastion_host.id]
  subnet_id = aws_subnet.public_subnet.id
  tags = {
      Name = "bastion host"
  }

  provisioner "file" {
    source      = "/home/eduiac/terra-infra/ec2Key.pem"
    destination = "/home/ec2-user/ec2Key.pem"

    connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = tls_private_key.private_key.private_key_pem
    host     = aws_instance.bastion_host.public_ip
    }
  }
}

# mysql ec2 instance
resource "aws_instance" "mysql" {
  depends_on = [
    aws_security_group.sg_mysql,
    aws_nat_gateway.nat_gateway,
    aws_route_table_association.associate_routetable_to_private_subnet,
  ]
  ami = "ami-0732b62d310b80e97"
  instance_type = "t2.micro"
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.sg_mysql.id]
  subnet_id = aws_subnet.private_subnet.id
  user_data = file("configure_mysql.sh")
  tags = {
      Name = "mysql-instance"
  }
}

# wordpress ec2 instance
resource "aws_instance" "wordpress" {
  depends_on = [
    aws_security_group.sg_wordpress,
    aws_instance.mysql
  ]
  ami = "ami-0732b62d310b80e97"
  instance_type = "t2.micro"
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.sg_wordpress.id]
  subnet_id = aws_subnet.public_subnet.id
  user_data = <<EOF
            #! /bin/bash
            yum update
            yum install docker -y
            systemctl restart docker
            systemctl enable docker
            docker pull wordpress
            docker run --name wordpress -p 80:80 -e WORDPRESS_DB_HOST=${aws_instance.mysql.private_ip} \
            -e WORDPRESS_DB_USER=root -e WORDPRESS_DB_PASSWORD=root -e WORDPRESS_DB_NAME=wordpressdb -d wordpress
  EOF

  tags = {
      Name = "wordpress"
  }
}