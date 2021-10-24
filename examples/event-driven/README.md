# Event-Driven Architecture with AWS Lambda

## Download example
Download this example on your workspace
```sh
git clone https://github.com/Young-ook/terraform-aws-lambda
cd terraform-aws-lambda/examples/event-driven
```

## Setup
[This](https://github.com/Young-ook/terraform-aws-lambda/blob/main/examples/event-driven/main.tf) is the example of terraform configuration file to create a lambda function. Check out and apply it using terraform command.

## Terraform
In this example, the lambda function depends on the artifact file in the s3 bucket. First we need to build the ci and s3 bucket modules. Run terraform:
```
$ terraform init
$ terraform apply -target module.ci -target module.artifact
```
Also you can use the `-var-file` option for customized paramters when you run the terraform plan/apply command.
```
$ terraform plan -var-file tc1.tfvars
$ terraform apply -var-file tc1.tfvars -target module.ci -target module.artifact
```

Next, run terraform on other resources including lambda function:
**[Note}** Don't forget you have to use the `-var-file` option if you ran terraform apply command with extra variable files in the previous step.
```
$ terraform apply
```

## Clean up
Run terraform:
```
$ terraform destroy
```
Don't forget you have to use the `-var-file` option when you run terraform destroy command to delete the aws resources created with extra variable files.
```
$ terraform destroy -var-file tc1.tfvars
```
