output "rds_endpoint" {
  value = "${aws_db_instance.db_wp.address}"
}

output "ec2_endpoint" {
  value = "${aws_instance.wp-app.public_ip}"
}

