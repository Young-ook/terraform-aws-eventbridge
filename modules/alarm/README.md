# AWS CloudWatch Alarm
Amazon CloudWatch is basically a metrics repository. An AWS service—such as Amazon EC2—puts metrics into the repository, and you retrieve statistics based on those metrics. If you put your own custom metrics into the repository, you can retrieve statistics on these metrics as well.

[AWS CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html) enables you to trigger an alarm when systems encounters a specific situation.

You can create both `metric` alarms and `composite` alarms in CloudWatch.

- A metric alarm watches a single CloudWatch metric or the result of a math expression based on CloudWatch metrics. The alarm performs one or more actions based on the value of the metric or expression relative to a threshold over a number of time periods. The action can be sending a notification to an Amazon SNS topic, performing an Amazon EC2 action or an Auto Scaling action, or creating an OpsItem or incident in Systems Manager.

- A composite alarm includes a rule expression that takes into account the alarm states of other alarms that you have created. The composite alarm goes into ALARM state only if all conditions of the rule are met. The alarms specified in a composite alarm's rule expression can include metric alarms and other composite alarms.

## Quickstart
### Setup
```hcl
module "alarm" {
  source  = "Young-ook/eventbridge/aws//modules/alarm"
  name    = "example"
}
```
Run terraform:
```
terraform init
terraform apply
```
