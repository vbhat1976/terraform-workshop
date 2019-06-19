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
            "Resource": "arn:aws:s3:::rockhola-di-${element(var.student_aliases, count.index)}"
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