provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

#------ EC2 ------
resource "aws_instance" "wp-app" {
  ami                         = "${var.ami}"
  lifecycle {
    create_before_destroy     = true
  }
  instance_type               = "t2.micro"
  user_data                   = "${data.template_file.user_data.rendered}"
  subnet_id                   = "${aws_subnet.wp_public_subnet_1.id}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.wp_instance.id}"]
  key_name                    = "aipk"

  tags {
    Name = "${var.ec2_instance_name}"
  }
}

#------ RDS ------
resource "aws_db_instance" "db-wp" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.6.37"
  instance_class         = "db.t2.micro"
  identifier             = "db-wp"
  name                   = "${var.rds_db_name}"
  username               = "${var.rds_user}"
  password               = "${data.aws_ssm_parameter.db-wp_password.value}"
  publicly_accessible    = true
  db_subnet_group_name   = "${aws_db_subnet_group.db_wp_subnet_group.id}"
  vpc_security_group_ids = ["${aws_security_group.rds_instance.id}"]

  tags {
    Name = "${var.rds_instance_name}"
  }
}
