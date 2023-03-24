resource "aws_db_subnet_group" "wilsonle-hobby-subnet-group" {
  name       = "wilsonle-hobby-subnet-group"
  subnet_ids = [aws_subnet.wilsonle-hobby-subnet-1.id, aws_subnet.wilsonle-hobby-subnet-2.id]

  tags = {
    Name = "wilsonle-hobby-subnet-group"
  }
}

resource "aws_db_instance" "wilsonle-hobby-database" {
  allocated_storage      = 10
  identifier             = "wilsonle-hobby-database"
  db_name                = var.database-secrets.DATABASE_NAME
  port                   = var.database-secrets.DATABASE_PORT
  engine                 = "postgres"
  engine_version         = "13.7"
  instance_class         = "db.t3.micro"
  username               = var.database-secrets.DATABASE_USERNAME
  password               = var.database-secrets.DATABASE_PASSWORD
  parameter_group_name   = "default.postgres13"
  publicly_accessible    = true
  skip_final_snapshot    = true
  apply_immediately      = true
  vpc_security_group_ids = [aws_security_group.wilsonle-hobby-security-group.id]
  db_subnet_group_name   = aws_db_subnet_group.wilsonle-hobby-subnet-group.name
}
