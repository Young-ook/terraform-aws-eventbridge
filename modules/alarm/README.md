# AWS CloudWatch Alarm

[AWS CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html) enables you to trigger an alarm when systems encounters a specific situation.

## Quickstart
### Setup
```hcl
module "alarm" {
  source  = "Young-ook/lambda/aws//modules/alarm"
  name    = "example"
}
```
Run terraform:
```
terraform init
terraform apply
```
