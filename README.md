[[English](README.md)] [[한국어](README.ko.md)]

# Amazon EventBridge
[Amazon EventBridge](https://aws.amazon.com/eventbridge) is a serverless event bus that makes it easier to build event-driven applications at scale using events generated from your applications, integrated Software-as-a-Service (SaaS) applications, and AWS services. EventBridge delivers a stream of real-time data from event sources such as Zendesk or Shopify to targets like AWS Lambda and other SaaS applications. You can set up routing rules to determine where to send your data to build application architectures that react in real-time to your data sources with event publisher and consumer completely decoupled.

## Examples
- [EDA (Event-Driven Architecture) Blueprint](https://github.com/Young-ook/terraform-aws-eventbridge/tree/main/examples/blueprint)

## Getting started
### AWS CLI
Follow the official guide to install and configure profiles.
- [AWS CLI Installation](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- [AWS CLI Configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)

### Terraform
Terraform is an open-source infrastructure as code software tool that enables you to safely and predictably create, change, and improve infrastructure.

#### Install
This is the official guide for terraform binary installation. Please visit this [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) website and follow the instructions.

Or, you can manually get a specific version of terraform binary from the websiate. Move to the [Downloads](https://www.terraform.io/downloads.html) page and look for the appropriate package for your system. Download the selected zip archive package. Unzip and install terraform by navigating to a directory included in your system's `PATH`.

Or, you can use [tfenv](https://github.com/tfutils/tfenv) utility. It is very useful and easy solution to install and switch the multiple versions of terraform-cli.

First, install tfenv using brew.
```
brew install tfenv
```
Then, you can use tfenv in your workspace like below.
```
tfenv install <version>
tfenv use <version>
```
Also this tool is helpful to upgrade terraform v0.12. It is a major release focused on configuration language improvements and thus includes some changes that you'll need to consider when upgrading. But the version 0.11 and 0.12 are very different. So if some codes are written in older version and others are in 0.12 it would be great for us to have nice tool to support quick switching of version.
```
tfenv list
tfenv install latest
tfenv use <version>
```

# Additional Resources
- [Building Event Driven Architectures](https://serverlessland.com/event-driven-architecture/intro)
- [6 Strategies for Migrating Applications to the Cloud](https://medium.com/aws-enterprise-collection/6-strategies-for-migrating-applications-to-the-cloud-eb4e85c412b4)
- [An E-Book of Cloud Best Practices for Your Enterprise](https://aws.amazon.com/blogs/enterprise-strategy/an-e-book-of-cloud-best-practices-for-your-enterprise/)
- [Tutorial: Schedule a Serverless Workflow with AWS Step Functions and Amazon EventBridge Scheduler](https://aws.amazon.com/tutorials/scheduling-a-serverless-workflow-step-functions-amazon-eventbridge-scheduler/)
- [Saga Pattern](https://microservices.io/patterns/data/saga.html)
- [Saga Pattern | Application Transactions Using Microservices – Part I](https://www.couchbase.com/blog/saga-pattern-implement-business-transactions-using-microservices-part/)
- [Saga Pattern | How to Implement Business Transactions Using Microservices – Part II](https://www.couchbase.com/blog/saga-pattern-implement-business-transactions-using-microservices-part-2/)
- [Azure Architecture Center: Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/)
- [AWS Serverless](https://aws.amazon.com/serverless/)
