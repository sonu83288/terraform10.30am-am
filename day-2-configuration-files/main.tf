resource "aws_instance" "dev" {
    ami = var.ami_id
    instance_type = var.type
    subnet_id = aws_subnet.name.id
    tags = {
      name ="dev"
    }
  
}
resource "aws_vpc" "dev" {
    cidr_block = "10.0.0.0/24"

  
}
resource "aws_subnet" "devvv" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
  

}

