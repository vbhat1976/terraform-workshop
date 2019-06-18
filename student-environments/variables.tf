variable "aws_access_key_id" {
  description   = "the AWS access key to use"
}

variable "aws_access_secret_key" {
  description   = "the AWS access key secret to use"
}

variable "aws_region" {
  description   = "the AWS region in which resources are created"
}

variable "student_aliases" {
  description   = "a list of student name aliases"
  type          = "list"
}