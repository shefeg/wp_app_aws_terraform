#!/bin/bash

# DESCRIPTION:
# Script to run manually to create AWS user and add policies for Terraform

USER=${1:-'terraform'}

aws iam create-user --user-name $USER
aws iam create-access-key --user-name $USER
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --user-name $USER
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --user-name $USER

