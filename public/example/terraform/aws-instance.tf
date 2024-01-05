provider "aws" {
  region = "us-west-1" # 원하는 리전으로 변경하세요
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet" {
  count           = 2
  vpc_id          = aws_vpc.my_vpc.id
  cidr_block      = "10.0.${count.index + 1}.0/24"
  availability_zone = "us-west-1a" # 원하는 가용 영역으로 변경하세요
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  count           = 2
  vpc_id          = aws_vpc.my_vpc.id
  cidr_block      = "10.0.${count.index + 3}.0/24"
  availability_zone = "us-west-1b" # 원하는 가용 영역으로 변경하세요
}

resource "aws_security_group" "allow_http" {
  name_prefix = "allow-http-"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_ssh" {
  name_prefix = "allow-ssh-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_instance" {
  count         = 2
  ami           = "ami-12345678" # 유효한 AMI ID로 변경하세요
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet[count.index].id
  security_groups = [aws_security_group.allow_http.name, aws_security_group.allow_ssh.name]
}

resource "aws_lb" "load_balancer" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public_subnet.*.id
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  launch_configuration = aws_launch_configuration.ec2_launch_config.name
}

resource "aws_launch_configuration" "ec2_launch_config" {
  name_prefix          = "ec2-launch-config-"
  image_id             = "ami-12345678" # 유효한 AMI ID로 변경하세요
  instance_type        = "t2.micro"
  security_groups     = [aws_security_group.allow_http.name, aws_security_group.allow_ssh.name]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from user data!"
              EOF
}