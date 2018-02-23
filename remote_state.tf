# terraform state file setup
# create an S3 bucket to store the state file in
resource "aws_s3_bucket" "terraform-state-storage-s3-oihn" {
  bucket = "terraform-remote-state-storage-s3-oihn"
  versioning {
    enabled = true
  }
  #   lifecycle {
  #   prevent_destroy = true
  # }

  tags {
    Name = "S3 Remote Terraform State Store"
  }      
}

# Stores the state as a given key in a given bucket on AWS
# with state locking and consistency checking via Dynamo DB
terraform {
  backend "s3" {
  encrypt = true
  bucket = "terraform-remote-state-storage-s3-oihn"
  dynamodb_table = "terraform_locks"
  region = "us-east-1"
  key = "terraform.tfstate"
 }
}