provider "aws" {
  region = "us-west-2"
}

#=================================S3 backend====================================
/*
terraform {
  backend "s3" {
    bucket = "aws.backend.test123123321" // Bucket where to SAVE Terraform State
    key    = "test/terraform.tfstate"    // Object name in the bucket to SAVE Terraform State
    region = "us-west-2"                 // Region where bycket created
  }
}
*/
#======================================VPC======================================

module "SG" {
  source = "./modules/SecurityGroup"
  allow_ports   = ["80", "22"]
}

module "network" {
  source = "./modules/network"
  env                  = "Test"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
}

module "EC2" {
  source = "./modules/EC2"
  instance_type_server = "t2.micro"
  key_name_for_server  = "Oregon-DevOps-Lab"
  port_lb_listener     = "80"
  protocol_lb_listener = "HTTP"
  depends_on = [
    module.network,
  ]
}

module "IAM_for_EC2" {
  source = "./modules/IAM"
}

module "ECS" {
  source = "./modules/ECS"
  env                  = "test"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  depends_on = [
    module.EC2,
  ]
}
