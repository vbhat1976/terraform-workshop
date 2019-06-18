variable "aws_profile" {
  description   = "the local AWS profile to use"
}

variable "aws_region" {
  description   = "the AWS region in which resources are created"
}

variable "student_aliases" {
  description   = "a list of student name aliases"
  type          = "list"
}