#!/bin/bash

values=$(terraform output -json)

let i=0
for username in $(echo $values | jq -r '.students.value[][]'); do
  echo "$username"
  echo $values | jq -r '.access_keys.value[]['"$i"']'
  echo $values | jq -r '.secret_keys.value[]['"$i"']'
  echo $values | jq -r '.passwords.value[]['"$i"']' | base64 --decode | gpg -dq
  echo ""
  let i=i+1
done