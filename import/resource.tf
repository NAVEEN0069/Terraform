resource "aws_instance" "test" {
   ami = "ami-0f8e81a3da6e2510a"
   instance_type= "t2.micro"
   vpc_security_group_id ="sg-0c6e23e3ee97290dc"
   subnet_id = "subnet-06d8c1c91591ae250"
   key = "TerraKey"
}

=======================================================================

# terraform show

# terraform import aws_instance.test i-04c6e84bde4539e6f

# In the import command, you should give #terraform import [resource_type.resource_name] [instance_id] 

