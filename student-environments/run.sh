#!/bin/bash

if [ -z "$AWS_PROFILE" ]; then
  AWS_PROFILE=rockholla-di
fi

if [ -z "$AWS_REGION" ]; then
  AWS_REGION="us-west-1"
fi

common_vars="-var aws_profile=$AWS_PROFILE -var aws_region=$AWS_REGION"
terraform init
if [[ "$1" == "apply" ]]; then
  if terraform plan $common_vars -out=plan.out; then
    read -p "If the plan above looks OK, press ENTER to continue, or CTRL+C to cancel"
    echo "Running apply of the plan..."
    terraform apply plan.out
  fi
elif [[ "$1" == "destroy" ]]; then
  terraform destroy $common_vars
else
  terraform $@
fi

