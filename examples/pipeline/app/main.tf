variable "artifact_bucket" {}

# lambda
module "lambda" {
  source = "Young-ook/lambda/aws"
  name   = "lambda-pipeline-example"
  lambda_config = {
    s3_bucket = var.artifact_bucket
    s3_key    = "lambda_handler.zip"
    handler   = "lambda_handler.lambda_handler"
  }
  policy_arns = [module.logs.policy_arns["write"]]
}

# cloudwatch logs
module "logs" {
  source = "Young-ook/lambda/aws//modules/logs"
  name   = "lambda-pipeline-example"
}
