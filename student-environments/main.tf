provider "aws" {
  version       = "~> 2.0"
  access_key    = "${var.aws_access_key_id}"
  secret_key    = "${var.aws_access_secret_key}"
  region        = "${var.aws_region}"
}

resource "aws_s3_bucket" "student_buckets" {
  count         = "${length(var.student_aliases)}"
  bucket        = "rockholla-di-${element(var.student_aliases, count.index)}"
  acl           = "private"
  region        = "${var.aws_region}"
  force_destroy = true
}

resource "aws_iam_account_password_policy" "students" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = false
  allow_users_to_change_password = true
}

resource "aws_iam_user" "students" {
  count         = "${length(var.student_aliases)}"
  name          = "${element(var.student_aliases, count.index)}"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "students" {
  count                   = "${length(var.student_aliases)}"
  user                    = "${element(var.student_aliases, count.index)}"
  password_length         = 10
  pgp_key                 = "${var.pgp_key}"
  password_reset_required = false
  lifecycle {
    ignore_changes = ["password_length", "password_reset_required", "pgp_key"]
  }
}

resource "aws_iam_user_policy" "student_bucket_access" {
  count     = "${length(var.student_aliases)}"
  name      = "${element(var.student_aliases, count.index)}BucketAccess"
  user      = "${element(var.student_aliases, count.index)}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowBase",
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:GetBucketLocation"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowListMyBucket",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "arn:aws:s3:::rockholla-di-${element(var.student_aliases, count.index)}"
        },
        {
            "Sid": "AllowAllInMyBucket",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "arn:aws:s3:::rockholla-di-${element(var.student_aliases, count.index)}/*"
        }
    ]
}
EOF
}

resource "aws_iam_access_key" "students" {
  count   = "${length(var.student_aliases)}"
  user    = "${element(var.student_aliases, count.index)}"
}