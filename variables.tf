variable "region" {}
variable "profile" {}
data "aws_availability_zones" "available" {}
variable "vpc_cidr" {}
variable "public_subnet_cidr_1" {}
variable "public_subnet_cidr_2" {}
variable "rds_instance_name" {}
variable "rds_db_name" {}
variable "rds_user" {}
data "aws_ssm_parameter" "db_wp_password" {
  name = "db_wp_password"
}
