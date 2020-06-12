variable "region" {
  default = "eu-central-1"
}
/*
variable "tf_state_bucket" {
  default = ""
}
*/
#=====Security Group

variable "allow_ports" {
  default = ["30000"]
}

#=====Network

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}

#=====EC2

variable "type_instance" {
  default = "t3.small"
}
/*
variable "asg_max_size" {
  default = ""
}

variable "asg_min_size" {
  default = ""
}

variable "asg_desired_capacity" {
  default = ""
}
*/
#=====K8S

variable "k8s_cluster_name" {
  default = "test-k8s-name"
}

#=====RDS
/*
variable "allocated_storage" {
  default = ""
}

variable "engine" {
  #default = "postgres"
  default = ""
}

variable "engine_version" {
  default = ""
}

variable "instance_class" {
  default = ""
}

variable "username" {
  default = ""
}

variable "db_allow_port" {
  default = ""
}

variable "backup_retention_period" {
  default = "8"
}

variable "rds_pswd_keeper" {
  description = "Password keeper"
  default     = ""
}
*/
#=====Tags

variable "env" {
  default = "dev"
}

variable "project" {
  default = "test-k8s"
}
