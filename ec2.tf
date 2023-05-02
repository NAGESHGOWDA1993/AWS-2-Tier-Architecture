#creating EC2 instance
resource "aws_instance" "Nagesh-web-tier1" {
  ami                         = "ami-0432c2005d3e6a7f4" #Amazon linux 2 AMI
  key_name                    = "kmaster"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public-subnet1.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.Week18-Public-SG-DB.id]
  user_data                   = <<-EOF
        #!/bin/bash
        yum update -y
        yum install httpd -y
        systemctl start httpd
        systemctl enable httpd
        echo "<html><body><h1>This is Nagesh Week18 Project Tier 1 </h1></body></html>" > /var/www/html/index.html
        EOF
  tags = {
    Name = "nagesh-EC2-1"
  }
}

#creating EC2 instance
resource "aws_instance" "Nagesh-web-tier2" {
  ami                         = "ami-0432c2005d3e6a7f4" #Amazon linux 2 AMI 
  key_name                    = "kmaster"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public-subnet2.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.Week18-Public-SG-DB.id]
  user_data                   = <<-EOF
        #!/bin/bash
        yum update -y
        yum install httpd -y
        systemctl start httpd
        systemctl enable httpd
        echo "<html><body><h1>This is Nagesh Week18 Project Tier 2 </h1></body></html>" > /var/www/html/index.html
        EOF
    tags = {
    Name = "nagesh-EC2-2"
  }
}