resource "aws_instance" "name" {
    ami = "ami-0c587d11c0a52bfbfg"
    instance_type = "t3.micro"
    tags = {
      name ="test"
    }
  
}


resource "aws_s3_bucket" "name" {
    bucket = "oiyufvbhca9dhiub"
  
}
# terraform apply -target=aws_s3_bucket.name