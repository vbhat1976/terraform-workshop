# Exercise #2: Using Variables

For this exercise, we will revisit the terraform project from the previous exercise.  There are a few ways 
to accomplish this, try doing each one independently.  If you get stuck, refer to the terraform in the 
"solution" directory as a reference.

There are many schools of thought on how to use variables to configure reusable terraform, 
but we will be exploring the core mechanics so that you as a student will understand the underlying processes
that the various methods exploint

### Looking at the variable stanza

In order to leverage the mechanics around the variable concept in terraform, you must declare each variable.

We have a single variable defined as:

```hcl
# Declare a variable so we can use it.
variable "student_alias" {
  description = "Your student alias"
}
```

The name of the variable above would be `student_alias`.

The possible properties of a variable:

1. `default`: allows for setting a default value, otherwise terraform requires it to be set:
    * via the CLI (`-var student_alias=my-alias`), 
    * defined in a *.tfvars file
    * defined in an environment variable like `TF_VAR_[variable name]`
    * or it will prompt for the input
2. `description`: a useful descriptor for the variable
3. `type`: one of map, list, or string

We've only set the description, so there's no default value, and it will use the default type of: string.

### Adding the values statically in the variables stanza.

You might notice that there is no "value" parameter in the syntax for the variable object.  
This is because the variables stanzas are not meant to be inputs themselves, but rather placeholders
that handle input and allow for reference throughout the working directory.  Though it is true that
variables stanzas can be used this way by simply setting the "default" to the desired value, this 
negates the benefits of Terraform's native re-usability.  Instead, try using one of the below methods.


### Initialization

Every time a new terraform working directory is created, we need to initialize it to prepare it to run against
the designated external API.  This does not need to happen after the first apply, just for new working directories.  
Before continuing, please ensure you are in the correct directory in the support resources.

```bash
terraform init
```

you should get an output similar to this:

```
Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "aws" (terraform-providers/aws) 2.15.0...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### tfvars file

In each terraform working directory, there can be a file named "terraform.tfvars" that contains HCL that defines 
values for variables for that working directory.  tfvar files can also be referenced via command line.  Let's try a 
few things.

* create a file called terraform.tfvars in this directory
* insert the following code into it:
```hcl
# swap "[your alias]" with your provided alias
student_alias = "[your alias]"
```
* then run this in the same directory
```bash
terraform plan
``` 

You should see that the terraform plan output includes an s3 bucket, and that the value for bucket_name 
utilizes your chosen identifying text.  If you have a different result, reference the tfvars folder under
the "solutions" folder for reference.

Remove your `terraform.tfvars` file so we can look at other ways of passing in the variable:

```
rm terraform.tfvars
```

### Command Line Arguments

Another method you can use is to insert variables via the CLI.  This allows for quick variable substitution and 
testing because values entered via CLI override values from other methods.

* run the following in this working directory (if you were able to complete the previous), swapping for your
identifier like before.

```bash
terraform plan -var 'student_alias=[your alias]'
```

* You can try using a different identifier to see if it worked.  Like before, you should 
be able to see the new identifier in the plan output.

### Using Environment variables

Environment variables can be used to set the value of an input variable in the root module. The name of the environment variable must be TF_VAR_ followed by the variable name, and the value is the value of the variable.

Try the following:

```bash
TF_VAR_student_alias=[your alias] terraform plan 
```

This can be a useful method for secrets handling, or other automated use cases.

### Prompt for a variable value

Try just running the plan without having a pre-populated value set, see what happens:

```
terraform plan
```

The above should prompt you for your `student_alias` value. The last way in which a variable can be set at runtime.

### Locals

A related concept that we will cover a little later is something called a local.  Locals act like variables, in that they
can be referenced from multiple locations, but locals can't take inputs like variables.  Locals also allow for 
interpolation, like merging strings or basing value on chained dependencies of locals.  Locals act more similiarly to
the standard variable you might be working with in Python, for example.  Here is an example:

```hcl
locals {
  title = "Student"
  name = "${var.student_alias}"
  name_and_title = "${local.name} - ${local.title}"
}
```

This is where we'll stop for now. We'll begin actually working with applying these plans in our next exercise.

