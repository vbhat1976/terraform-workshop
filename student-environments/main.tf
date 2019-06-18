provider "aws" {
  version       = "~> 2.0"
  access_key    = "${var.aws_access_key_id}"
  secret_key    = "${var.aws_access_secret_key}"
  region        = "${var.aws_region}"
}

resource "aws_s3_bucket" "student_buckets" {
  count  = "${length(var.student_aliases)}"
  bucket = "rockholla-di-${element(var.student_aliases, count.index)}"
  acl    = "private"
  region = "${var.aws_region}"
}

resource "aws_iam_user" "students" {
  count         = "${length(var.student_aliases)}"
  name          = "${element(var.student_aliases, count.index)}"
  force_destroy = true
}

resource "aws_iam_access_key" "students" {
  count   = "${length(var.student_aliases)}"
  user    = "${element(var.student_aliases, count.index)}"
}