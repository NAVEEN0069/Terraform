resource "aws_instance" "test" {
  ami= "ami-014d05e6b24240371"
  instance_type = "t2.micro"
  key_name = "TerraKey"
 tags = {
  Name = "Test01"
}

  provisioner "file" {
    source      = "/root/sample.txt"
    destination = "/tmp/sample.txt"
  }
 connection {
    type     = "ssh"
    user     = "ubuntu"
    password = " "
    private_key = file("Terra")
    host     = self.public_ip
  }
}
