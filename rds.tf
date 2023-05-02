#creating RDS Database
resource "aws_db_instance" "nagesh_database" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  db_subnet_group_name   = aws_db_subnet_group.nagesh-week18-subgroup.id
  vpc_security_group_ids = [aws_security_group.Week18-Public-SG-DB.id]
  name                   = "nagesh_database"
  username               = "username" #you can create the username you want. I won't be entering one because I'm pushing to Github
  password               = "password" #you can create the password you want. I won't be entering one becayse I'm pushing to Github
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  tags = {
    Name = "Nagesh-RDSDatabase"
  }
}

#creating private security group for Database tier
resource "aws_security_group" "nagesh_database_tier_lu" {
  name        = "nagesh_database_tier_lu"
  description = "allow traffic from SSH & HTTP"
  vpc_id      = aws_vpc.week18-vpc.id

  ingress {
    from_port       = 8279 #default port is 3306. You can also use 3307 & 8279 like myself
    to_port         = 8279
    protocol        = "tcp"
    cidr_blocks     = ["10.0.0.0/16"]
    security_groups = [aws_security_group.Nagesh-sg.id]
  }
  ingress {
    from_port   = 22
    to_port     = 22
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