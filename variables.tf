variable "allocated_storage" {
  default = "20"
}

variable "engine" {
  default = "mysql"
}

variable "engine_version" {
  default = "5.7"
}

variable "instance_class" {
  default = "db.t2.micro"
}

variable "username" {
  default = "superuser"
}

variable "password" {
  default = "superuserpassword"
}

variable "port" {
  default = "1488"
}

variable "backup_retention_period" {
  default = "0"
}

variable "env" {
  default = "test"
}
