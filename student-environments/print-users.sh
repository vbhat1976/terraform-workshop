#!/bin/bash

values=$(terraform output -json)

let i=0
for username in $(echo $values | jq -r '.students.value[].name'); do
  for loop in 1; do
	echo "Instructions repo:     https://github.com/sridhar09/terraform-workshop/"
	echo "Console URL:           https://introterraform.signin.aws.amazon.com/console"
	echo "Username/Alias:        $username"
	password=$(echo $values | jq -r '.passwords.value[]['"$i"']' | base64 --decode | gpg -dq -u B7592B7EB69D9F8C)
	echo "AWS Console Password:  $password"
	region=$(echo $values | jq -r '.students.value['"$i"'].region')
	echo "Exercise 11 Region:    $region"
	echo "Link to the slides:    https://docs.google.com/presentation/d/1XLqFMH7JyabnrIL-CGc_dQsSyXh5ZWtQ79A8VVP2Cl4/edit?usp=sharing"
	echo "Instructor email:      sridhar@datacouch.io"
	#echo "Course Evaluation:     $(cat survey-link)"
	echo ""
	echo ""
	echo ""
	let i=i+1
  done > tf-user$i
done
