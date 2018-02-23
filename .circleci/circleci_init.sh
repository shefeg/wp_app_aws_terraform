#!/usr/bin/env bash

# DESCRIPTION:
# Script to create S3 bucket and Dynamo DB table for terraform remote state storage
# Should be run at the start of CircleCI pipeline

# REGION="us-east-1"

set -e
BUCKET="terraform-remote-state-storage-s3-oihn"
aws s3api create-bucket --bucket $BUCKET --region $REGION
[[ "$(aws dynamodb create-table \
         --region $REGION \
         --table-name terraform_locks \
         --attribute-definitions AttributeName=LockID,AttributeType=S \
         --key-schema AttributeName=LockID,KeyType=HASH \
         --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 2>&1)" != *"ResourceInUseException"* ]] || true