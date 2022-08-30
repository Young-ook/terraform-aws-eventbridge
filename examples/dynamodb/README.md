# Amazon DynamoDB
This lambda and dynamodb example is based on [Using Lambda with API Gateway](https://docs.aws.amazon.com/lambda/latest/dg/services-apigateway-tutorial.html) tutorial. For more details, please refer to the original guide.

## Download example
Download this example on your workspace
```sh
git clone https://github.com/Young-ook/terraform-aws-lambda
cd terraform-aws-lambda/examples/dynamodb
```

## Setup
[This](https://github.com/Young-ook/terraform-aws-lambda/blob/main/examples/dynamodb/main.tf) is the example of terraform configuration file to create Amazon DynamoDB NoSQL database. Check out and apply it using terraform command.

## Terraform
Run terraform:
```
terraform init
terraform apply
```
Also you can use the `-var-file` option for customized paramters when you run the terraform plan/apply command.
```
terraform apply -var-file fixture.tc1.tfvars
```

## Lambda function scaling
The first time you invoke your function, AWS Lambda creates an instance of the function and runs its handler method to process the event. When the function returns a response, it stays active and waits to process additional events. If you invoke the function again while the first event is being processed, Lambda initializes another instance, and the function processes the two events concurrently. As more events come in, Lambda routes them to available instances and creates new instances as needed. When the number of requests decreases, Lambda stops unused instances to free up scaling capacity for other functions.

The default regional concurrency quota starts at 1,000 instances. For more information, or to request an increase on this quota, see [Lambda quotas](https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html). To allocate capacity on a per-function basis, you can configure functions with [reserved concurrency](https://docs.aws.amazon.com/lambda/latest/dg/configuration-concurrency.html).

## Clean up
Run terraform:
```
terraform destroy
```
Don't forget you have to use the `-var-file` option when you run terraform destroy command to delete the aws resources created with extra variable files.
```
terraform destroy -var-file fixture.tc1.tfvars
```
