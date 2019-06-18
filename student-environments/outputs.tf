output "students" {
  value = "${aws_iam_access_key.students.user}"
}

output "access_keys" {
  value = "${aws_iam_access_key.students.id}"
}

output "secret_keys" {
  value = "${aws_iam_access_key.students.secret}"
}