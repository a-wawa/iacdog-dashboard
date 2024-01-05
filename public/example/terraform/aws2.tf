resource "aws_vpc" "ic_vpc_1" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "ic_subnet_1" {
  vpc_id = aws_vpc.ic_vpc_1.id
  cidr_block = "10.0.1.0/24"
}
#name : vpc_subnet_server
resource "aws_instance" "ic_instance_1" {
  subnet_id = "${aws_subnet.ic_subnet_1.id}"
  ami = "ami-0b0dcb5067f052a63"
  instance_type = "t2.micro"
}

resource "aws_subnet" "ic_subnet_2" {
  vpc_id = aws_vpc.ic_vpc_1.id
  cidr_block = "10.0.2.0/24"
}
resource "aws_instance" "ic_instance_2" {
  subnet_id = "${aws_subnet.ic_subnet_1.id}"
  ami = "ami-0b0dcb5067f052a63"
  instance_type = "t2.micro"
}


resource "aws_vpc" "ic_vpc_2" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "ic_subnet_3" {
  vpc_id = aws_vpc.ic_vpc_2.id
  cidr_block = "10.1.1.0/24"
}
resource "aws_instance" "ic_instance_3" {
  subnet_id = "${aws_subnet.ic_subnet_3.id}"
  ami = "ami-0b0dcb5067f052a63"
  instance_type = "t2.micro"
}
resource "aws_instance" "ic_instance_4" {
  subnet_id = "${aws_subnet.ic_subnet_3.id}"
  ami = "ami-0b0dcb5067f052a63"
  instance_type = "t2.micro"
}

#vpc_id : source
#peer_vpc_id : destination
resource "aws_vpc_peering_connection" "ic_vpc_connection_1" {
  peer_vpc_id = "${aws_vpc.ic_vpc_1.id}"
  vpc_id      = "${aws_vpc.ic_vpc_2.id}"
}
resource "aws_vpc_peering_connection" "ic_vpc_connection_2" {
  peer_vpc_id = "${aws_vpc.ic_vpc_2.id}"
  vpc_id      = "${aws_vpc.ic_vpc_1.id}"
}
