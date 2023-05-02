#creating a VPC
resource "aws_vpc" "week18-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "LUweek18vpc"
  }
}

#creating internet gateway
resource "aws_internet_gateway" "Week18-Gateway" {
  vpc_id = aws_vpc.week18-vpc.id

  tags = {
    Name = "Nagesh-Internet-Gateway"
  }
}

#creating elastic IP address
resource "aws_eip" "Week18-Elastic-IP" {
  vpc = true
}

#creating NAT gateway
resource "aws_nat_gateway" "Week18-NAT-Gateway" {
  allocation_id = aws_eip.Week18-Elastic-IP.id
  subnet_id     = aws_subnet.public-subnet2.id
}

#creating NAT route
resource "aws_route_table" "Week18-Route-two" {
  vpc_id = aws_vpc.week18-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Week18-NAT-Gateway.id
  }

  tags = {
    Name = "Nagesh-Week18-Network-Address-Route"
  }
}

#creating public subnet
resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.week18-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "nagesh-public-subnet1"
  }
}

#creating public subnet
resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.week18-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "nagesh-public-subnet2"
  }
}

#creating private subnet
resource "aws_subnet" "private-subnet1" {
  vpc_id                  = aws_vpc.week18-vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "nagesh-private-subnet1"
  }
}

#creating private subnet
resource "aws_subnet" "private-subnet2" {
  vpc_id                  = aws_vpc.week18-vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "nagesh-private-subnet2"
  }
}

#creating subnet group
resource "aws_db_subnet_group" "nagesh-week18-subgroup" {
  name       = "nagesh-week18-subgroup"
  subnet_ids = [aws_subnet.private-subnet1.id, aws_subnet.private-subnet2.id]
  tags = {
    Name = "Nagesh data base subnet group"
  }
}

#creating route table association
resource "aws_route_table_association" "Week18-Route-two-1" {
  subnet_id      = aws_subnet.private-subnet1.id
  route_table_id = aws_route_table.Week18-Route-two.id
}
resource "aws_route_table_association" "Week18-Route-two-2" {
  subnet_id      = aws_subnet.private-subnet2.id
  route_table_id = aws_route_table.Week18-Route-two.id
}

#creating a security group
resource "aws_security_group" "Nagesh-sg" {
  name        = "Nagesh-sg"
  description = "security group for load balancer"
  vpc_id      = aws_vpc.week18-vpc.id

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#creating a load balancer
resource "aws_lb" "Nagesh-lb" {
  name               = "Nagesh-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public-subnet1.id, aws_subnet.public-subnet2.id]
  security_groups    = [aws_security_group.Nagesh-sg.id]
}

#creating load balancer security group
resource "aws_lb_target_group" "Nagesh-lb-tg" {
  name     = "week18targetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.week18-vpc.id

  depends_on = [aws_vpc.week18-vpc]
}

#creating load balancer target group
resource "aws_lb_target_group_attachment" "Nagesh-target-group1" {
  target_group_arn = aws_lb_target_group.Nagesh-lb-tg.arn
  target_id        = aws_instance.Nagesh-web-tier1.id
  port             = 80

  depends_on = [aws_instance.Nagesh-web-tier1]
}
#creating load balancer target group
resource "aws_lb_target_group_attachment" "Nagesh-target-group2" {
  target_group_arn = aws_lb_target_group.Nagesh-lb-tg.arn
  target_id        = aws_instance.Nagesh-web-tier2.id
  port             = 80

  depends_on = [aws_instance.Nagesh-web-tier2]
}
#creating load balancer listener
resource "aws_lb_listener" "nagesh-listener" {
  load_balancer_arn = aws_lb.Nagesh-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Nagesh-lb-tg.arn
  }
}

#creating route table
resource "aws_route_table" "Nagesh-Web-Tier" {
  tags = {
    Name = "Nagesh-Web-Tier"
  }
  vpc_id = aws_vpc.week18-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Week18-Gateway.id
  }
}

#creating route table association
resource "aws_route_table_association" "Week18-web-tier1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.Nagesh-Web-Tier.id
}

#creating route table association
resource "aws_route_table_association" "Week18-web-tier2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.Nagesh-Web-Tier.id
}

#creating route table
resource "aws_route_table" "Week18-DataBase-Tier" {
  tags = {
    Name = "DataBase-Tier"
  }
  vpc_id = aws_vpc.week18-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Week18-Gateway.id
  }
}

#creating public security group
resource "aws_security_group" "Week18-Public-SG-DB" {
  name        = "Week18-Public-SG-DB"
  description = "web and SSH allowed"
  vpc_id      = aws_vpc.week18-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}