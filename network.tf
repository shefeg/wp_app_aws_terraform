#------ VPC ------

resource "aws_vpc" "wp_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "wp_vpc"
  }
}

#-- subnets --
resource "aws_subnet" "wp_public_subnet_1" {
  vpc_id                  = "${aws_vpc.wp_vpc.id}"
  cidr_block              = "${var.public_subnet_cidr_1}"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true

  tags {
    Name = "wp_public_subnet_1"
  }
}

resource "aws_subnet" "wp_public_subnet_2" {
  vpc_id                  = "${aws_vpc.wp_vpc.id}"
  cidr_block              = "${var.public_subnet_cidr_2}"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true

  tags {
    Name = "wp_public_subnet_2"
  }
}

resource "aws_db_subnet_group" "db_wp_subnet_group" {
  name       = "db_wp_subnet_group"
  subnet_ids = ["${aws_subnet.wp_public_subnet_1.id}", "${aws_subnet.wp_public_subnet_2.id}"]

  tags {
    Name = "db_wp_subnet_group"
  }
}

#-- internet gateway --
resource "aws_internet_gateway" "wp_igw" {
  vpc_id = "${aws_vpc.wp_vpc.id}"

  tags {
    Name = "wp_igw"
  }
}

#-- route tables --
resource "aws_route_table" "wp_public_route_1" {
  vpc_id = "${aws_vpc.wp_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.wp_igw.id}"
  }

  tags {
    Name = "wp_public_route_1"
  }
}

resource "aws_route_table" "wp_public_route_2" {
  vpc_id = "${aws_vpc.wp_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.wp_igw.id}"
  }

  tags {
    Name = "wp_public_route_2"
  }
}

resource "aws_route_table_association" "rt_a_1" {
  subnet_id      = "${aws_subnet.wp_public_subnet_1.id}"
  route_table_id = "${aws_route_table.wp_public_route_1.id}"
}

resource "aws_route_table_association" "rt_a_2" {
  subnet_id      = "${aws_subnet.wp_public_subnet_2.id}"
  route_table_id = "${aws_route_table.wp_public_route_2.id}"
}

#-- security groups --
resource "aws_security_group" "rds_instance" {
  name   = "rds_instance"
  vpc_id = "${aws_vpc.wp_vpc.id}"
}

resource "aws_security_group" "wp_instance" {
  name   = "wp_instance"
  vpc_id = "${aws_vpc.wp_vpc.id}"
}

resource "aws_security_group_rule" "rds_instance_3306_inbound" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.rds_instance.id}"
  source_security_group_id = "${aws_security_group.wp_instance.id}"
}

resource "aws_security_group_rule" "rds_instance_3306_open" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.rds_instance.id}"
  cidr_blocks              = ["194.44.35.131/32"]
}

resource "aws_security_group_rule" "wp_instance_80_inbound" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.wp_instance.id}"
}

resource "aws_security_group_rule" "wp_instance_22_inbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["194.44.35.131/32"]
  security_group_id = "${aws_security_group.wp_instance.id}"
}

resource "aws_security_group_rule" "wp_instance_allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.wp_instance.id}"
}


