# 프로바이더 설정 (AWS 사용)
provider "aws" {
  region = "ap-northeast-2" # 서울 리전
}

# 첫 번째 VPC 생성
resource "aws_vpc" "first_vpc" {
  cidr_block = "10.0.0.0/16"
}

# 첫 번째 서브넷 생성
resource "aws_subnet" "first_subnet" {
  vpc_id            = aws_vpc.first_vpc.id
  cidr_block        = "10.0.0.0/24"
}

# S3 버킷 생성
resource "aws_s3_bucket" "first_s3_bucket" {
  bucket = "first-s3-bucket"
}

# 두 번째 VPC 생성
resource "aws_vpc" "second_vpc" {
  cidr_block = "10.1.0.0/16"
}

# 첫 번째 서브넷 생성
resource "aws_subnet" "second_subnet_1" {
  vpc_id            = aws_vpc.second_vpc.id
  cidr_block        = "10.1.0.0/24"
}

# 두 번째 서브넷 생성
resource "aws_subnet" "second_subnet_2" {
  vpc_id            = aws_vpc.second_vpc.id
  cidr_block        = "10.1.1.0/24"
}

# 첫 번째 VPC의 서브넷에 EC2 인스턴스 생성
resource "aws_instance" "ec2_instance" {
  # EC2 인스턴스 AMI ID
  ami           = "ami-03baa3575a5f30358" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.first_subnet.id
}

# 두 번째 VPC의 첫 번째 서브넷에 EC2 인스턴스 생성
resource "aws_instance" "ec2_instance_1" {
  # EC2 인스턴스 AMI ID
  ami           = "ami-03baa3575a5f30358" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.second_subnet_1.id
}

# 두 번째 VPC의 두 번째 서브넷에 EC2 인스턴스 생성
resource "aws_instance" "ec2_instance_2" {
  # EC2 인스턴스 AMI ID
  ami           = "ami-03baa3575a5f30358" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.second_subnet_2.id
}

resource "aws_vpc_peering_connection" "ic_vpc_connection_2" {
  peer_vpc_id = "${aws_vpc.first_vpc.id}"
  vpc_id      = "${aws_vpc.second_vpc.id}"
}
