# Event-Driven Architecture (EDA) with Amazon EventBridge and AWS Lambda

## Download example
Download this example on your workspace
```sh
git clone https://github.com/Young-ook/terraform-aws-lambda
cd terraform-aws-lambda/examples/eventbridge
```

## Setup
[This](https://github.com/Young-ook/terraform-aws-lambda/blob/main/examples/eventbridge/main.tf) is the example of terraform configuration file to create a lambda function. Check out and apply it using terraform command.

If you don't have the terraform tool in your environment, go to the main [page](https://github.com/Young-ook/terraform-aws-lambda) of this repository and follow the installation instructions.

## Terraform
Run terraform:
```
$ terraform init
$ terraform apply
```
Also you can use the `-var-file` option for customized paramters when you run the terraform plan/apply command.
```
$ terraform init
$ terraform apply -var-file tc1.tfvars
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
