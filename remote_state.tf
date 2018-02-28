# Terraform state file setup
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