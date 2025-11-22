resource "aws_instance" "jenkins_agent" {
  ami           = "ami-02b297871a94f4b42"  # Replace with a valid AMI ID
  instance_type = "t3.micro"
  
  tags = {
    Name        = "Jenkins-Build-Agent-01"  # <--- THIS IS THE AWS INSTANCE NAME
    Environment = "Dev"
  }
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







