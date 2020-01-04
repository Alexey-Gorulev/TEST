provider "aws" {
  region = "us-west-2"
}

##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "example" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}

#####
# DB
#####
resource "aws_db_instance" "project" {

  identifier = "${var.env}-db-server"

  engine            = "${var.engine}"
  engine_version    = "${var.engine_version}"
  instance_class    = "${var.instance_class}"
  allocated_storage = "${var.allocated_storage}"
  storage_encrypted = false

  name     = "${var.env}"
  username = "${var.username}"
  password = "${var.password}"
  port     = "${var.port}"

  vpc_security_group_ids = [data.aws_security_group.default.id]
  /*
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
*/
  # disable backups to create DB faster
  backup_retention_period = "${var.backup_retention_period}"

  tags = {
    Owner       = "user"
    Environment = "${var.env}"
  }

  # DB subnet group
  db_subnet_group_name = aws_db_subnet_group.project.id

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "${var.env}-db-server-snapshot"
  /*
  timezone = "Central Standard Time"
*/
}

resource "aws_db_subnet_group" "project" {
  name       = "db_subnet_group"
  subnet_ids = data.aws_subnet_ids.example.ids

  tags = {
    Name = "${var.env}-db_subnet_group"
  }
}
