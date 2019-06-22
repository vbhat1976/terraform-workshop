# main.tf

# Declare the provider being used, in this case it's AWS.
# This provider supports setting the provider version, AWS credentials as well as the region.
# It can also pull credentials and the region to use from environment variables, which we have set, so we'll use those
provider "aws" {
  version = "~> 2.0"
}

# declare a resource stanza so we can create something.
data "aws_ami" "ubuntu" {
	most_recent = true

	filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
	}

	filter {
    name   = "virtualization-type"
    values = ["hvm"]
	}

	owners = ["099720109477"] # Canonical
}

output "most_recent_ubuntu_ami_id" {
	value = "${data.aws_ami.ubuntu.id}"
}