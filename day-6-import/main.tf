resource "aws_instance" "name" {
    ami = "ami-00e15f0027b9bf02b"
    instance_type = "t3.micro"
    tags = {
      name = "test"
    }

  
}