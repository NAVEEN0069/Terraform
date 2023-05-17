resource "aws_instance" "test" {
  ami = "ami-014d05e6b24240371"
  instance_type= "t2.micro"
  key_name   = "TerraKey"
  tags = {
    Name = "test-teraform"
  }
}

resource "aws_instance" "web" {
  ami          = var.ami
  instance_type = var.type

  tags = {
    Name = var.name
  }
}
