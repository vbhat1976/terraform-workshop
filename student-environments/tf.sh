#!/bin/bash

export TF_VAR_pgp_key=$(gpg --export "rockholla-di" | base64)
terraform init
if [[ "$1" == "apply" ]]; then
  terraform plan -out=plan.out | tee plan.log
  if [[ ${PIPESTATUS[0]} == 0 ]]; then
  	if ! cat plan.log | grep "No changes. Infrastructure is up-to-date." &> /dev/null; then
	  read -p "If the plan above looks OK, press ENTER to continue, or CTRL+C to cancel"
	  echo "Running apply of the plan..."
	  terraform apply plan.out
	else
	  terraform output
	fi
  fi
elif [[ "$1" == "destroy" ]]; then
  terraform destroy
else
  terraform $@
fi

