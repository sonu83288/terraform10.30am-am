#create vpc
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      name ="cust-vpc"
    }
  
}
#create subnet
resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-west-2a"
    tags = {
      name ="cust-suubnet-1-public"
    }
  
}
resource "aws_subnet" "name-2" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-west-2b"
    tags = {
      name = "cust-subnet-2-private"
    }
  
}
#create igw and attach to vpc
resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.name.id
    tags = {
        name = "cust-igw"
    }
  
}
#create route table and edit routes
resource "aws_route_table" "name" {
    vpc_id = aws_vpc.name.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.name.id

    }
  
}
#create subnet association
resource "aws_route_table_association" "name" {
    subnet_id = aws_subnet.name.id
    route_table_id = aws_route_table.name.id
  
}
#create sg
resource "aws_security_group" "dev_sg" {
  name   = "allow_tls"
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "dev-sg"
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#create surver
resource "aws_instance" "public-surver" {
    ami = "ami-0c587d11c0a52bfbf"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.name.id
    vpc_security_group_ids = [aws_security_group.dev_sg.id]
    associate_public_ip_address = true
  
}
resource "aws_instance" "private-surver" {
    ami = "ami-0c587d11c0a52bfbf"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.name-2.id
    vpc_security_group_ids = [aws_security_group.dev_sg.id]
}