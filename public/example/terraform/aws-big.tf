# sds.tf

resource "aws_vpc" "cand1" {
  cidr_block = "10.1.0.0/16"
}


# autoscaling and elb connect
resource "aws_subnet" "cand1_cand1lb" {
  vpc_id = "${aws_vpc.cand1.id}"
  cidr_block = cidrsubnet(aws_vpc.cand1.cidr_block, 8, 1)
}

resource "aws_internet_gateway" "cand1" {

}
resource "aws_internet_gateway_attachment" "cand1" {
  internet_gateway_id = "${aws_internet_gateway.cand1.id}"
  vpc_id              = "${aws_vpc.cand1.id}"
}


resource "aws_launch_configuration" "cand1" {
  name          = "web_config"
  image_id      = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
}
resource "aws_autoscaling_group" "cand1_cand1" {
  vpc_zone_identifier = [aws_subnet.cand1_cand1lb.id]
  max_size = 4
  min_size = 2
  desired_capacity = 2
  launch_configuration = "${aws_launch_configuration.cand1.id}"
  health_check_grace_period = 300
  health_check_type         = "ELB"
}


resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.cand1_cand1.name
  lb_target_group_arn    = aws_lb_target_group.cand1.arn
}

resource "aws_lb_target_group" "cand1" {
  name     = "cand1"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.cand1.id
}

resource "aws_lb" "cand1" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.cand1_cand1lb.id]

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "cand1" {
  protocol = "TCP"
  port = 80
  load_balancer_arn = "${aws_lb.cand1.id}"
  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.cand1.arn}"
  }
}


#s3 and server connection
resource "aws_subnet" "cand1_cand2" {
  vpc_id = "${aws_vpc.cand1.id}"
  cidr_block = cidrsubnet(aws_vpc.cand1.cidr_block, 8, 2)
}

resource "aws_vpc_endpoint" "cand1_2" {
  service_name = "com.amazonaws.us-east-1.s3"
  vpc_id       = aws_vpc.cand1.id
  vpc_endpoint_type = "Interface"
  tags = {
    name = "cand1"
  }
}
resource "aws_vpc_endpoint_subnet_association" "cand1" {
  vpc_endpoint_id = aws_vpc_endpoint.cand1_2.id
  subnet_id       = aws_subnet.cand1_cand2.id
}



resource "aws_subnet" "cand1_cand3" {
  vpc_id = "${aws_vpc.cand1.id}"
  cidr_block = cidrsubnet(aws_vpc.cand1.cidr_block, 8, 3)
}

resource "aws_instance" "cand1_cand3_cand1" {
  ami           = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.cand1_cand3.id
  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = 12
  }
}
resource "aws_ebs_volume" "cand1" {
  availability_zone = "${aws_instance.cand1_cand3_cand1.availability_zone}"
  size = 10
}
resource "aws_ebs_volume" "cand2" {
  availability_zone = "${aws_instance.cand1_cand3_cand1.availability_zone}"
  size = 6
}
resource "aws_ebs_volume" "cand3" {
  availability_zone = "${aws_instance.cand1_cand3_cand1.availability_zone}"
  size = 8
}

resource "aws_volume_attachment" "cand1" {
  device_name = "/dev/sdf"
  instance_id = "${aws_instance.cand1_cand3_cand1.id}"
  volume_id   = "${aws_ebs_volume.cand1.id}"
}
resource "aws_volume_attachment" "cand2" {
  device_name = "/dev/sde"
  instance_id = "${aws_instance.cand1_cand3_cand1.id}"
  volume_id   = "${aws_ebs_volume.cand2.id}"
}
resource "aws_volume_attachment" "cand3" {
  device_name = "/dev/sdd"
  instance_id = "${aws_instance.cand1_cand3_cand1.id}"
  volume_id   = "${aws_ebs_volume.cand3.id}"
}



resource "aws_vpc_peering_connection" "cand1" {
  peer_vpc_id = "${aws_vpc.cand1.id}"
  vpc_id      = "${aws_vpc.cand2.id}"
}
resource "aws_vpc_peering_connection_accepter" "cand1" {
  vpc_peering_connection_id = "${aws_vpc_peering_connection.cand1.id}"
  auto_accept = true
}

resource "aws_vpc" "cand2" {
  cidr_block = "10.2.0.0/16"
}
resource "aws_route_table" "cand2" {
  vpc_id = aws_vpc.cand2.id
}

# vpc peering connect
resource "aws_route" "cand1" {
  route_table_id = "${aws_route_table.cand2.id}"
  destination_cidr_block = "10.1.0.0/16"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.cand1.id}"
}

resource "aws_subnet" "cand2_cand1" {
  vpc_id = "${aws_vpc.cand2.id}"
  cidr_block = cidrsubnet(aws_vpc.cand2.cidr_block, 8, 1)
}



#nat gateway cand2_cand2-3
resource "aws_subnet" "cand2_cand2" {
  vpc_id = "${aws_vpc.cand2.id}"
  cidr_block = cidrsubnet(aws_vpc.cand2.cidr_block, 8, 2)
}

resource "aws_internet_gateway" "cand2_1" {}
resource "aws_internet_gateway_attachment" "cand2_1" {
  internet_gateway_id = "${aws_internet_gateway.cand2_1.id}"
  vpc_id              = "${aws_vpc.cand2.id}"
}
resource "aws_eip" "cand1" {
  vpc = true
}
resource "aws_nat_gateway" "cand1" {
  allocation_id = "${aws_eip.cand1.id}"
  subnet_id     = "${aws_subnet.cand2_cand2.id}"
}

resource "aws_subnet" "cand2_cand3" {
  vpc_id = "${aws_vpc.cand2.id}"
  cidr_block = cidrsubnet(aws_vpc.cand2.cidr_block, 8, 3)
}

resource "aws_route_table" "cand2_cand2_cand1" {
  vpc_id = aws_vpc.cand2.id
}
resource "aws_route" "cand2_2_1_natgatewaytest" {
  route_table_id          = "${aws_route_table.cand2_cand2_cand1.id}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id          = "${aws_nat_gateway.cand1.id}"
}
resource "aws_route_table_association" "cand2_2_1_natgatewaytest" {
  route_table_id = "${aws_route_table.cand2_cand2_cand1.id}"
  subnet_id = "${aws_subnet.cand2_cand3.id}"
}



resource "aws_subnet" "cand2_cand4" {
  vpc_id = "${aws_vpc.cand2.id}"
  cidr_block = cidrsubnet(aws_vpc.cand2.cidr_block, 8, 4)
}

resource "aws_iam_instance_profile" "cand1" {
  name = "test_profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "test_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}
resource "aws_instance" "cand2_cand4_cand1" {
  ami           = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.cand2_cand4.id
  iam_instance_profile = "${aws_iam_instance_profile.cand1.id}"
}







#efs test
resource "aws_vpc" "cand3" {
  cidr_block = "10.3.0.0/16"
}
resource "aws_subnet" "cand3_cand1" {
  vpc_id = "${aws_vpc.cand3.id}"
  cidr_block = cidrsubnet(aws_vpc.cand3.cidr_block, 8, 1)
}
resource "aws_efs_file_system" "cand1" {
  creation_token = "test"
}
resource "aws_efs_mount_target" "cand1" {
  file_system_id = "${aws_efs_file_system.cand1.id}"
  subnet_id      = "${aws_subnet.cand3_cand1.id}"
}



resource "aws_subnet" "cand3_cand2" {
  vpc_id = "${aws_vpc.cand3.id}"
  cidr_block = cidrsubnet(aws_vpc.cand3.cidr_block, 8, 2)
}

resource "aws_vpc" "cand4" {
  cidr_block = "10.4.0.0/16"
}
resource "aws_subnet" "cand4_cand1" {
  vpc_id = "${aws_vpc.cand4.id}"
  cidr_block = cidrsubnet(aws_vpc.cand4.cidr_block, 8, 1)
}
resource "aws_subnet" "cand4_cand2" {
  vpc_id = "${aws_vpc.cand4.id}"
  cidr_block = cidrsubnet(aws_vpc.cand4.cidr_block, 8, 2)
}
resource "aws_subnet" "cand4_cand3" {
  vpc_id = "${aws_vpc.cand4.id}"
  cidr_block = cidrsubnet(aws_vpc.cand4.cidr_block, 8, 3)
}
resource "aws_subnet" "cand4_cand4" {
  vpc_id = "${aws_vpc.cand4.id}"
  cidr_block = cidrsubnet(aws_vpc.cand4.cidr_block, 8, 4)
}
resource "aws_subnet" "cand4_cand5" {
  vpc_id = "${aws_vpc.cand4.id}"
  cidr_block = cidrsubnet(aws_vpc.cand4.cidr_block, 8, 5)
}