# main.tf

# Declare the provider being used, in this case it's AWS.
# This provider supports setting the provider version, AWS credentials as well as the region.
# It can also pull credentials and the region to use from environment variables, which we have set, so we'll use those
terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.1.0"
    }
  }
}

provider "local" {
  # Configuration options
}

# declare a resource stanza so we can create something.
resource "local_file" "my_file" {
  content = "Hello, Terraform"
  filename = "${path.module}/sridhar.txt"
}q
