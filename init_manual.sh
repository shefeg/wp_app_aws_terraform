#!/bin/bash

# DESCRIPTION:
# Script to run manually to create AWS: user, access keys and policies for Terraform

USER="terraform"
REGION="us-east-1"

aws iam create-user --user-name $USER
aws iam create-access-key --user-name $USER
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --user-name $USER
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --user-name $USER

