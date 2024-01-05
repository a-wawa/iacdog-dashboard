provider "aws" {
  region     = "ap-northeast-2"
}

provider "aws" {
  region     = "ap-northeast-1"
  alias      = "tokyo"
}

resource "aws_vpc" "seoul_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_vpc" "seoul_vpc_test" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_vpc_peering_connection" "seoul_vpc_connection" {
  peer_vpc_id = "${aws_vpc.seoul_vpc.id}"
  vpc_id      = "${aws_vpc.seoul_vpc_test.id}"
}

resource "aws_subnet" "seoul_subnet" {
  vpc_id            = aws_vpc.seoul_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-northeast-2a"
}

resource "aws_subnet" "seoul_subnet_test_1" {
  vpc_id            = aws_vpc.seoul_vpc_test.id
  cidr_block        = "10.1.0.0/24"
  availability_zone = "ap-northeast-2a"
}

resource "aws_subnet" "seoul_subnet_test_2" {
  vpc_id            = aws_vpc.seoul_vpc_test.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "ap-northeast-2a"
}

resource "aws_instance" "seoul_server" {
  subnet_id     = aws_subnet.seoul_subnet.id
  ami           = var.seoul_ubuntu_ami
  instance_type = "t2.micro"
}

resource "aws_instance" "seoul_server_test_1" {
  subnet_id     = aws_subnet.seoul_subnet_test_1.id
  ami           = var.seoul_ubuntu_ami
  instance_type = "t2.micro"
}

resource "aws_instance" "seoul_server_test_2" {
  subnet_id     = aws_subnet.seoul_subnet_test_2.id
  ami           = var.seoul_ubuntu_ami
  instance_type = "t2.micro"
}

resource "aws_vpc" "tokyo_vpc" {
  provider   = aws.tokyo
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "tokyo_subnet" {
  provider   = aws.tokyo
  vpc_id     = aws_vpc.tokyo_vpc.id
  cidr_block = "10.1.0.0/24"
}

resource "aws_instance" "tokyo_server" {
  provider      = aws.tokyo
  subnet_id     = aws_subnet.tokyo_subnet.id
  ami           = var.tokyo_ubuntu_ami
  instance_type = "t2.micro"
}

resource "aws_instance" "tokyo_server_test" {
  provider      = aws.tokyo
  subnet_id     = aws_subnet.tokyo_subnet.id
  ami           = var.tokyo_ubuntu_ami
  instance_type = "t2.micro"
}


variable "tokyo_ubuntu_ami" {
  type        = string
  default     = "ami-0d52744d6551d851e"
  description = "tokyo ubuntu ami 22.04 LTS"
}

variable "seoul_ubuntu_ami" {
  type        = string
  default     = "ami-0c9c942bd7bf113a2"
  description = "seoul ubuntu ami 22.04 LTS"
}
