output "students" {
  value = ["${aws_iam_access_key.students.*.user}"]
}

output "access_keys" {
  value = ["${aws_iam_access_key.students.*.id}"]
}

output "secret_keys" {
  value = ["${aws_iam_access_key.students.*.secret}"]
}

output "passwords" {
  value = ["${aws_iam_user_login_profile.students.*.encrypted_password}"]
}