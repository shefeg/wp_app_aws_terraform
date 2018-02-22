#!/bin/sh

USER="terraform"
REGION="us-east-1"

set -e
[[ "$(aws iam create-user --user-name $USER 2>&1)" = *"EntityAlreadyExists"* ]] && true
[[ $(aws iam list-access-keys --user-name $USER) ]] || aws iam create-access-key --user-name $USER
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --user-name $USER
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --user-name $USER
aws s3api create-bucket --bucket terraform-remote-state-storage-s3-oihn --region $REGION
[[ "$(aws dynamodb create-table \
         --region $REGION \
         --table-name terraform_locks \
         --attribute-definitions AttributeName=LockID,AttributeType=S \
         --key-schema AttributeName=LockID,KeyType=HASH \
         --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 2>&1)" = *"ResourceInUseException"* ]] && true