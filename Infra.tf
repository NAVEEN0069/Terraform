provider "aws" {
  #version = "~> 2.0"
  region  = "us-east-1"
}

#creating a VPC
resource "aws_vpc" "myvpc" {
   cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "terraformvpc"
  }
}

#creating a public subnet and mapping with the VPC created above
resource "aws_subnet" "pubsub" {
   vpc_id     = "${aws_vpc.myvpc.id}"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "publicsubnet"
  }
}

#creating a private subnet and mapping with VPC created above
resource "aws_subnet" "privsub" {
   vpc_id     = "${aws_vpc.myvpc.id}"
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "privatesubnet"
  }
}

#creating a internet gateway to the above VPC ID
resource "aws_internet_gateway" "tigw" {
  vpc_id = "${aws_vpc.myvpc.id}"

  tags = {
    Name = "IGW"
  }
}

#creating a public route table  and  Mapping IGW with route table
resource "aws_route_table" "pubrt" {
  vpc_id = "${aws_vpc.myvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tigw.id}"
  }

  tags = {
    Name = "publicRT"
  }
}

# Mapping public Subnet and route table which are created above
resource "aws_route_table_association" "pubassoc" {
  subnet_id      = "${aws_subnet.pubsub.id}"
  route_table_id = "${aws_route_table.pubrt.id}"
}

#creating a Elastic IP
resource "aws_eip" "eip" {
  vpc = true
}

#creating a nat gateway and allocating EIP and to public subnet
resource "aws_nat_gateway" "tnat" {
   allocation_id = "${aws_eip.eip.id}"
  subnet_id     = "${aws_subnet.pubsub.id}"
}


#creating a private route table and mapping with nat IP
resource "aws_route_table" "privrt" {
  vpc_id = "${aws_vpc.myvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.tnat.id}"
  }

  tags = {
    Name = "privateRT"
  }
}

# Mapping private Subnet and private route table which are created above
resource "aws_route_table_association" "privassoc" {
  subnet_id      = "${aws_subnet.privsub.id}"
  route_table_id = "${aws_route_table.privrt.id}"
}

#security group

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.myvpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating ec2 instance public instance
resource "aws_instance" "Jumpbox" {
  ami                         = "ami-098f16afa9edf40be"
  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.pubsub.id}"
  key_name                    = "testmug"
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  user_data = <<-EOF
              #!/bin/bash
              yum install httpd -y
              service httpd start
              echo "Hello Terraform" > /var/www/html/index.html
              EOF
               tags = {
    Name = "public instance"
  }
}


resource "aws_instance" "private" {
  ami                         = "ami-098f16afa9edf40be"
  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.privsub.id}"
  key_name                    = "testmug"
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
}


#ping www.google.com

[ec2-user@first_machine ~]$ ssh ec2-user@10.0.2.14

#ssh ec2-user@privateIpof2ndmachine
#yes
#ping www.google.com


Create a VPC

Create a Public Sunbnet

Create a Private subnet

cerate a Internet gateway

	creating a route table  and  Mapping IGW with route table
	
	Mapping public Subnet and route table which are created above
	
create a Elastic IP

create a Nat Gateway ans associate elastic IP with it


	create a Private route table


	Mapping private Subnet and private route table which are created above
	
Create a Security group

Creating ec2 instance public instance

Creating ec2 private instance

