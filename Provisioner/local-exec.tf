resource "aws_instance" "webserver" {
  ami           = "ami-014d05e6b24240371"
  instance_type = "t2.micro"
  provisioner "local-exec" {
    command = "echo Instance ${aws_instance.webserver.public_ip} Created! > /tmp/instance_state.txt"
  }
}
