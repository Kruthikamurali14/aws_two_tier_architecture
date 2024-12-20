terraform {
  required_version = "~> 1.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "new_vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.new_vpc.id
  availability_zone       = each.value.availability_zone
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.new_vpc.id
  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.new_vpc.id
}

resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.new_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt_assoc_1" {
  route_table_id = aws_route_table.main_rt.id
  subnet_id      = aws_subnet.public["public_subnet_1"].id
}

resource "aws_route_table_association" "rt_assoc_2" {
  route_table_id = aws_route_table.main_rt.id
  subnet_id      = aws_subnet.public["public_subnet_2"].id
}

resource "aws_security_group" "alb_sg" {
  vpc_id      = aws_vpc.new_vpc.id
  description = "The security group for the ALB"
  name        = "ALB_SG"

  ingress {
    description = "http from users"
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

  tags = {
    Name        = "ALB security group"
    Environment = "Test"
  }
}

resource "aws_security_group" "ec2-sg" {
  vpc_id = aws_vpc.new_vpc.id
  name   = "ec2_security_group"

  ingress {
    description     = "allow Http"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.alb_sg.id] # Only from the ALB security group
  }

  ingress {
    description     = "allow ssh"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.alb_sg.id] # Only from the ALB security group
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_lb_target_group" "target_group" {
  name     = "alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.new_vpc.id
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  for_each = {
    instance_1 = aws_instance.instance_1.id
    instance_2 = aws_instance.instance_2.id
  }
  target_group_arn = aws_lb_target_group.target_group.id
  target_id        = each.value
  port             = 80
}


resource "aws_instance" "instance_1" {
  ami             = var.ami_id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ec2-sg.id]
  subnet_id       = aws_subnet.public["public_subnet_1"].id
  key_name        = var.key_name
  user_data       = filebase64("user_data.sh")

}

resource "aws_instance" "instance_2" {
  ami             = var.ami_id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ec2-sg.id]
  subnet_id       = aws_subnet.public["public_subnet_2"].id
  key_name        = var.key_name
  user_data       = filebase64("user_data.sh")
}

resource "aws_lb" "alb" {
  name               = "Test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_security_group" "db-sg" {
  name        = var.db-sg-name
  vpc_id      = aws_vpc.new_vpc.id
  description = "Allow inbound traffic"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2-sg.id] # Allow only from the EC2 security group
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "db-subnet-grp" {
  name       = var.db-subnet-name
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]
}


resource "aws_db_instance" "rds-1" {
  allocated_storage      = 10
  db_name                = "rds_db"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = var.db-username
  password               = var.db-password
  db_subnet_group_name   = aws_db_subnet_group.db-subnet-grp.name
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  skip_final_snapshot    = true
}
