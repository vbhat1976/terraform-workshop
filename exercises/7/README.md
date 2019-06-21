# Error Handling, Troubleshooting

We'll take some time to look at what the different types of errors we discussed look like.
In each part of this exercise you'll get a feel for some common error scenarios and how to
fix or address them.

### Process Errors

So, as mentioned, process errors really about just something wrong happening when running
terraform, either in the way you did it, or due to other factors. So, what happens when you
run `apply` before `init`? Let's run apply here before init:

```bash
terraform apply
```

You should see something like:

```Error: Could not satisfy plugin requirements


Plugin reinitialization required. Please run "terraform init".

Plugins are external binaries that Terraform uses to access and manipulate
resources. The configuration provided requires plugins which can't be located,
don't satisfy the version constraints, or are otherwise incompatible.

Terraform automatically discovers provider requirements from your
configuration, including providers used in child modules. To see the
requirements and constraints from each module, run "terraform providers".



Error: provider.aws: no suitable version installed
  version requirements: "~> 2.0"
  versions installed: none
```

One of `init`'s jobs is to ensure that dependencies like providers, modules, etc. are pulled
in and available locally within your project directory. If we don't run `init` first, none of
our other terraform operations have all the requirements they need to do their job.

How about another process error example, the apply command has an argument that will tell it
to never prompt you for input variables: `-input=[true|false]`. By default, it's true, but we
could try running apply with it set to false.

```bash
terraform init
terraform apply -input=false
```

Which should give you something like:

```
Error: Unassigned variable

The input variable "student_alias" has not been assigned a value. This is a
bug in Terraform; please report it in a GitHub issue.
```

### Syntactical Errors

Let's modify the main.tf file here to include something invalid. At the end of the file, add this:

```hcl
resource "aws_s3_bucket_object" "an_invalid_resource_definition" {
```

Clearly a syntax problem, so let's run

```
terraform plan
```

And you should see something like

```
Error: Invalid resource name

  on main.tf line 17:
   1: # main.tf

# Declare the provider being used, in this case it's AWS.
# This provider supports setting the provider version, AWS credentials as well as the region.
# It can also pull credentials and the region to use from environment variables, which we have set, so we'll use those
provider "aws" {
  version = "~> 2.0"
}

# declare a resource stanza so we can create something.
resource "aws_s3_bucket_object" "user_student_alias_object" {
  bucket  = "rockholla-di-${var.student_alias}"
  key     = "student.alias"
  content = "This bucket is reserved for ${var.student_alias}"
}

resource "aws_s3_bucket_object" # main.tf
  17: resource "aws_s3_bucket_object" # main.tf

# Declare the provider being used, in this case it's AWS.
# This provider supports setting the provider version, AWS credentials as well as the region.
# It can also pull credentials and the region to use from environment variables, which we have set, so we'll use those
provider "aws" {
  version = "~> 2.0"
}

# declare a resource stanza so we can create something.
resource "aws_s3_bucket_object" "user_student_alias_object" {
  bucket  = "rockholla-di-${var.student_alias}"
  key     = "student.alias"
  content = "This bucket is reserved for ${var.student_alias}"
}

resource "aws_s3_bucket_object" "an_invalid_resource_definition {

A name must start with a letter and may contain only letters, digits,
underscores, and dashes.


Error: Unterminated string literal

  on main.tf line 17:
  17: 

Unable to find the closing quote mark before the end of the file.


Error: Invalid block definition

  on main.tf line 17:
  17: 

Either a quoted string block label or an opening brace ("{") is expected here.
```

Here, we're just getting used to what things look like depending on our type of error encountered

### Validation Errors

This one might not be as clear to the eye as the syntax problem above. Let's pass something invalid
to the AWS provider by setting a property that doesn't exist according to the `aws_s3_bucket_object`
resource as defined in the AWS provider. Let's modify the syntax problem above slightly, so change
your resource definition to be:

```hcl
resource "aws_s3_bucket_object" "an_invalid_resource_definition" {
  key     = "student.alias"
  content = "This bucket is reserved for ${var.student_alias}"
}
```

Nothing seemingly wrong with the above when looking at it, unless you know that the `bucket` property
is a required one on this type of resource. So, let's see what terraform tells us about this:

```bash
terraform validate
```

First, here we see the `terraform validate` command at work. We could just as easily do a `terraform plan`
and get a similar result. Two benefits of validate:

1. It allows validation of things without having to worry about everything we would in the normal process of plan or apply. For example, variables don't need to be set.
2. Related to the above, it's a good tool to consider for a continuous integration and/or delivery/deployment pipeline. Failing fast is an important part of any validation or testing tool.

Having run `terraform validate` you should see something like the following:

```
Error: Missing required argument

  on main.tf line 17, in resource "aws_s3_bucket_object" "an_invalid_resource_definition":
  17: resource "aws_s3_bucket_object" "an_invalid_resource_definition" {

The argument "bucket" is required, but no definition was found.
```

So, our provider is actually giving us this. The AWS provider defines what a `aws_s3_bucket_object` should include,
and what is required. The `bucket` property is required, so it's tell us this.

### Provider Errors or Passthrough

And now to the most frustrating ones! These may be random, intermittent. They will be very specific to the provider and problems
that happen when actually trying to do the work of setting up or maintaining your resources. Let's take a look at a simple example.
Modify the invalid resource we've been working with here in `main.tf` to now be:

```hcl
resource "aws_s3_bucket_object" "a_resource_that_will_fail" {
  bucket  = "a-bucket-that-doesnt-exist-or-i-dont-own"
  key     = "file"
  content = "This will never exist"
}
```

