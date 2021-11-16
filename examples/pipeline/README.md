# AWS CodePipeline

## Download example
Download this example on your workspace
```sh
git clone https://github.com/Young-ook/terraform-aws-lambda
cd terraform-aws-lambda/examples/pipeline
```

## Setup
[This](https://github.com/Young-ook/terraform-aws-lambda/blob/main/examples/pipeline/main.tf) is the example of terraform configuration file to create code pipeline workflow. Check out and apply it using terraform command.

### Terraform
Run terraform:
```
$ terraform init
$ terraform apply
```
Also you can use the `-var-file` option for customized paramters when you run the terraform plan/apply command.
```
$ terraform plan -var-file tc1.tfvars
$ terraform apply -var-file tc1.tfvars
```

### GitHub connection
A connection created through the AWS CLI or Terraform is in `PENDING` status by default. After you create a connection with the CLI or Terraform, use the console to edit the connection to make its status `AVAILABLE` before you move to the next step.

For more details, open the AWS official [guide](https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-update.html) and follow the instructions.

## Clean up
Run terraform:
```
$ terraform destroy
```
Don't forget you have to use the `-var-file` option when you run terraform destroy command to delete the aws resources created with extra variable files.
```
$ terraform destroy -var-file tc1.tfvars
```
