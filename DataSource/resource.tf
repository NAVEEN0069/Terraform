resource "aws_instance" "test" {
  ami = "ami-014d05e6b24240371"
  instance_type = data.aws_ec2_instance_type.example.id
}

data "aws_ec2_instance_type" "example" {
  instance_type = "t2.micro"
}
