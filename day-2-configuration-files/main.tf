resource "aws_instance" "dev" {
    ami = var.ami_id
    instance_type = var.type
    subnet_id = aws_subnet.name.id
    tags = {
      name ="dev"
    }
  
}
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/24"
    tags = {
       name ="sonu"
      }

  
}
resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
  

}






