variable "profile" {
  default = "default"
}

variable "region" {
  default = "us-east-1"
}

data "aws_availability_zones" "available" {}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
  default = "10.0.1.0/24"
}

variable "public_subnet_cidr_2" {
  default = "10.0.2.0/24"
}

variable "ami" {
  default = "ami-26ebbc5c"
}

variable "ssh_key" {
  default = "aipk"
}

variable "ec2_instance_name" {
  default = "wp-app"
}

variable "rds_instance_name" {
  default = "db-wp"
}

variable "rds_db_name" {
  default = "vasyadb"
}

variable "rds_user" {
  default = "vasya"
}

data "aws_ssm_parameter" "db-wp_password" {
  name = "db_wp_password"
}

data "template_file" "user_data" {
  template = "${file("user_data.sh")}"
}
