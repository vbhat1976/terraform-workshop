#!/bin/bash

values=$(terraform output -json)

let i=0
for username in $(echo $values | jq -r '.students.value[][]'); do
  echo "$username"
  printf "access key: "
  printf $values | jq -r '.access_keys.value[]['"$i"']'
  printf "\n"
  printf "secret key: "
  printf $values | jq -r '.secret_keys.value[]['"$i"']'
  printf "\n"
  printf "password: "
  printf $values | jq -r '.passwords.value[]['"$i"']' | base64 --decode | gpg -dq
  printf "\n\n"
  let i=i+1
done