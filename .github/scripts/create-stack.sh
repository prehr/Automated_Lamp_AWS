#!/bin/bash

REGION="us-east-1"
STACK_NAME=$1
TEMPLATE=$2
if ! aws cloudformation describe-stacks --region $REGION --stack-name $STACK_NAME ; then
  echo "Creating stack ${STACK_NAME} as it does not exist"
  if aws cloudformation create-stack --region $REGION --stack-name $STACK_NAME --capabilities CAPABILITY_NAMED_IAM --template-body "file://${TEMPLATE}"; then
    aws cloudformation wait stack-create-complete --region $REGION --stack-name ${STACK_NAME};
  fi
else
  echo "Updating stack ${STACK_NAME} as it already exists"
  if aws cloudformation update-stack --region $REGION --stack-name $STACK_NAME --capabilities CAPABILITY_NAMED_IAM --template-body "file://${TEMPLATE}"; then
    aws cloudformation wait stack-update-complete --region $REGION --stack-name ${STACK_NAME}
  fi
fi