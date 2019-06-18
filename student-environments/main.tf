provider "aws" {
  version   = "~> 2.0"
  profile   = "${var.aws_profile}"
  region    = "${var.aws_region}"
}

resource "aws_s3_bucket" "student_buckets" {
  count  = "${length(var.student_aliases)}"
  bucket = "rockholla-di-${element(var.student_aliases, count.index)}"
  acl    = "private"
  region = "${var.aws_region}"
}