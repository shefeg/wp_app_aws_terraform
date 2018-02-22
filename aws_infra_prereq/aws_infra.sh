#!/bin/bash

USER="terraform"

aws iam create-user --user-name $USER && aws iam create-access-key --user-name $USER && \
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --user-name $USER
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --user-name $USER
aws s3api create-bucket --bucket terraform-remote-state-storage-s3-oihn --region us-east-1
aws dynamodb create-table \
         --region us-east-1 \
         --table-name terraform_locks \
         --attribute-definitions AttributeName=LockID,AttributeType=S \
         --key-schema AttributeName=LockID,KeyType=HASH \
         --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1
cd ../s3_state
terraform init
terraform apply -auto-approve