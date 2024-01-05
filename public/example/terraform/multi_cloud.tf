terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.8.0"
    }
    
    ncloud = {
      source = "navercloudplatform/ncloud"
    }
  }
  required_version = ">= 1.1.6"
}

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

resource "aws_subnet" "seoul_subnet" {
  vpc_id            = aws_vpc.seoul_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-northeast-2a"
}

resource "aws_instance" "seoul_server" {
  subnet_id     = aws_subnet.seoul_subnet.id
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

// ncloud 구성
provider "ncloud" {
  support_vpc = true
  region = "KR"
  access_key = var.access_key
  secret_key = var.secret_key
}

variable "name_scn01" {
  default = "tf-scn01"
}

variable "client_ip" {
  default = "777.777.777.777"
}

variable "access_key" {
  default = "access_key"
}

variable "secret_key" {
  default = "secret_key"
}

resource "ncloud_login_key" "key_scn_01" {
  key_name = var.name_scn01
}

resource "ncloud_vpc" "vpc_scn_01" {
  name = var.name_scn01
  ipv4_cidr_block = "10.0.0.0/16"
}

resource "ncloud_vpc" "vpc_scn_02" {
  name = "tf-scn02"
  ipv4_cidr_block = "10.0.2.0/16"
}

resource "ncloud_vpc_peering" "vpc_peering_01" {
  name = "01to02"
  source_vpc_no = ncloud_vpc.vpc_scn_01.id
  target_vpc_no = ncloud_vpc.vpc_scn_02.id
}

resource "ncloud_subnet" "subnet_scn_01" {
  name = var.name_scn01
  vpc_no = ncloud_vpc.vpc_scn_01.id
  subnet = cidrsubnet(ncloud_vpc.vpc_scn_01.ipv4_cidr_block, 8, 1)
  // 10.0.1.0/24
  zone = "KR-2"
  network_acl_no = ncloud_vpc.vpc_scn_01.default_network_acl_no
  subnet_type = "PUBLIC"
  // PUBLIC(Public) | PRIVATE(Private)
}

resource "ncloud_server" "server_scn_01" {
  subnet_no = ncloud_subnet.subnet_scn_01.id
  name = var.name_scn01
  server_image_product_code = "SW.VSVR.OS.LNX64.CNTOS.0703.B100"
  login_key_name = ncloud_login_key.key_scn_01.key_name
}

resource "ncloud_public_ip" "public_ip_scn_01" {
  server_instance_no = ncloud_server.server_scn_01.id
  description = "for ${var.name_scn01}"
}

locals {
  scn01_inbound = [
    [1, "TCP", "0.0.0.0/0", "80", "ALLOW"],
    [2, "TCP", "0.0.0.0/0", "443", "ALLOW"],
    [3, "TCP", "${var.client_ip}/32", "22", "ALLOW"],
    [4, "TCP", "${var.client_ip}/32", "3389", "ALLOW"],
    [5, "TCP", "0.0.0.0/0", "32768-65535", "ALLOW"],
    [197, "TCP", "0.0.0.0/0", "1-65535", "DROP"],
    [198, "UDP", "0.0.0.0/0", "1-65535", "DROP"],
    [199, "ICMP", "0.0.0.0/0", null, "DROP"],
  ]

  scn01_outbound = [
    [1, "TCP", "0.0.0.0/0", "80", "ALLOW"],
    [2, "TCP", "0.0.0.0/0", "443", "ALLOW"],
    [3, "TCP", "${var.client_ip}/32", "1000-65535", "ALLOW"],
    [197, "TCP", "0.0.0.0/0", "1-65535", "DROP"],
    [198, "UDP", "0.0.0.0/0", "1-65535", "DROP"],
    [199, "ICMP", "0.0.0.0/0", null, "DROP"]
  ]
}

resource "ncloud_network_acl_rule" "network_acl_01_rule" {
  network_acl_no = ncloud_vpc.vpc_scn_01.default_network_acl_no
  dynamic "inbound" {
    for_each = local.scn01_inbound
    content {
      priority = inbound.value[0]
      protocol = inbound.value[1]
      ip_block = inbound.value[2]
      port_range = inbound.value[3]
      rule_action = inbound.value[4]
      description = "for ${var.name_scn01}"
    }
  }

  dynamic "outbound" {
    for_each = local.scn01_outbound
    content {
      priority = outbound.value[0]
      protocol = outbound.value[1]
      ip_block = outbound.value[2]
      port_range = outbound.value[3]
      rule_action = outbound.value[4]
      description = "for ${var.name_scn01}"
    }
  }
}
