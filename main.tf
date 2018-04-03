provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

#------ LOCALS ------
locals {
  env="${terraform.workspace}"

  counts = {
    "dev"  = 1
    "prod" = 1
  }

  aws_instances = {
    "dev"  = "t2.micro"
    "prod" = "t2.micro"
  }

  rds_instances = {
    "dev"  = "db.t2.micro"
    "prod" = "db.t2.micro"
  }

  instance_type  = "${lookup(local.aws_instances,local.env)}"
  instance_class = "${lookup(local.rds_instances,local.env)}"
}

#------ EC2 ------
resource "aws_instance" "wp-app" {
  ami                         = "${var.ami}"
  lifecycle {
    create_before_destroy     = true
  }
  instance_type               = "${local.instance_type}"
  user_data                   = "${data.template_file.user_data.rendered}"
  subnet_id                   = "${aws_subnet.wp_public_subnet_1.id}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.wp_instance.id}"]
  key_name                    = "${var.ssh_key}"

  tags {
    Name = "${var.ec2_instance_name}-${terraform.workspace}"
  }
}

#------ RDS ------
resource "aws_db_instance" "db-wp" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.6.37"
  instance_class         = "${local.instance_class}"
  identifier             = "${var.rds_instance_name}-${terraform.workspace}"
  name                   = "${var.rds_db_name}"
  username               = "${var.rds_user}"
  password               = "${data.aws_ssm_parameter.db-wp_password.value}"
  publicly_accessible    = true
  db_subnet_group_name   = "${aws_db_subnet_group.db_wp_subnet_group.id}"
  vpc_security_group_ids = ["${aws_security_group.rds_instance.id}"]
  skip_final_snapshot    = true  

  tags {
    Name = "${var.rds_instance_name}-${terraform.workspace}"
  }
}
