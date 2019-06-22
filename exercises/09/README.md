# Resource Counts and Conditionals

The idea of looping in Terraform is one of the most encountered gotchas. Declarative infrastructure tools 
and languages often require or encourage more explicit definition of things rather than supporting logic 
where other languages might have an "easier" way of doing things. Nonetheless, there's still a good deal
you can accomplish via Terraform's `count` concept that mimicks the idea of loops and creating multiple
copies or versions of a single thing. Let's take a look at an example using the s3 bucket object we've seen
before

Run the following in this directory

```bash
terraform init
terraform plan
```