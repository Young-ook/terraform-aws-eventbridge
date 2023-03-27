[[English](README.md)] [[한국어](README.ko.md)]

# Applications
## Amazon API Gateway
This is an example of lambda functions with AWS API Gateway and Amazon DynamoDB. Here is the original version of tutorial: [Using Lambda with API Gateway](https://docs.aws.amazon.com/lambda/latest/dg/services-apigateway-tutorial.html). For more details, please refer to the official document.

The first time you invoke your function, AWS Lambda creates an instance of the function and runs its handler method to process the event. When the function returns a response, it stays active and waits to process additional events. If you invoke the function again while the first event is being processed, Lambda initializes another instance, and the function processes the two events concurrently. As more events come in, Lambda routes them to available instances and creates new instances as needed. When the number of requests decreases, Lambda stops unused instances to free up scaling capacity for other functions.

The default regional concurrency quota starts at 1,000 instances. For more information, or to request an increase on this quota, see [Lambda quotas](https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html). To allocate capacity on a per-function basis, you can configure functions with [reserved concurrency](https://docs.aws.amazon.com/lambda/latest/dg/configuration-concurrency.html).
