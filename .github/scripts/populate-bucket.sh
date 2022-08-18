#!/bin/bash

S3_BUCKET="lamp-resource-bucket"

if aws s3 ls "s3://$S3_BUCKET" 2>&1 | grep -q 'NoSuchBucket'
then
    aws s3 mb s3://$S3_BUCKET --region us-east-1
fi

aws s3 sync ./apache s3://$S3_BUCKET/apache --delete