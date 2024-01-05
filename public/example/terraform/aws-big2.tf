provider "aws" {
    region = "us-east-1"
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}

resource "aws_vpc" "main_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "main_vpc"
    }
}

variable "for_subnet" {
    default = {
        subnet1 = "first"
        subnet2 = "second"
        subnet3 = "third"
    }
}

resource "aws_subnet" "for_subnet" {
    for_each = var.for_subnet
    vpc_id = aws_vpc.main_vpc.id
}

resource "aws_instance" "for_instance" {
    for_each = var.for_subnet
    subnet_id = aws_subnet.for_subnet[each.key].id
}

variable "count_subnet" {
    default = 100
}

resource "aws_subnet" "count_subnet" {
    count = var.count_subnet
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, count.index + 3)
}
