#!/bin/bash

common_vars="-var aws_access_key_id=$AWS_ACCESS_KEY_ID -var aws_access_secret_key=$AWS_SECRET_ACCESS_KEY -var aws_region=$AWS_DEFAULT_REGION"
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

