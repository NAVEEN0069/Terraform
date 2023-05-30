resource "aws_instance" "test" {
  ami           = "ami-014d05e6b24240371"
  instance_type = "t2.micro"
  key_name      = "TerraKey"
  tags = {
    Name = "test1"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install nginx -y",
      "sudo systemctl start nginx"
    ]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = " "
    private_key = file("Terra")
    host        = self.public_ip
  }
}
