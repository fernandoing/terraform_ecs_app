provider "aws" {
  region = var.region
}

resource "aws_db_instance" "instance" {
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_type
  username             = var.username
  password             = var.password
  #parameter_group_name = join(".",["default", var.engine, var.engine_version])
  skip_final_snapshot  = true
  
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  db_subnet_group_name = aws_db_subnet_group.instance_subnets.name

  backup_retention_period = 0
  publicly_accessible = false
}

resource "aws_db_subnet_group" "instance_subnets" {
  name       = join("-", ["default", var.engine, var.engine_version])
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My database subnet group"
  }
}

resource "aws_security_group" "instance_sg" {
  name   = "allow_mysql"
  vpc_id = var.vpc_id

  ingress {
    description = "MySQL from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.sg_cidr_blocks
  }
}
