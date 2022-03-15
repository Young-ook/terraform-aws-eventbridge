# Event-Driven Architecture (EDA) with Message Queue

## Download example
Download this example on your workspace
```sh
git clone https://github.com/Young-ook/terraform-aws-lambda
cd terraform-aws-lambda/examples/mq
```

## Setup
[This](https://github.com/Young-ook/terraform-aws-lambda/blob/main/examples/mq/main.tf) is the example of terraform configuration file to create event-drivern application with serverless functions and message broker. Check out and apply it using terraform command.

## Terraform
Run terraform:
```
$ terraform init
$ terraform apply
```
Also you can use the `-var-file` option for customized paramters when you run the terraform plan/apply command.
```
$ terraform apply -var-file fixture.tc1.tfvars
```

## RabbitMQ
### Messaging with RabbitMQ
RabbitMQ uses AMQP 0-9-1 protocol for connectivity. Messaging in RabbitMQ is based on the concept of exchange, routing key, bindings and queues. A message sender sends messages to an exchange along with a routing key. Receivers get messages from a queue which is bound to an exchange using a binding key. More details on RabbitMQ messaging concepts can be found in their official [documentation](https://www.rabbitmq.com/getstarted.html).

### Exchange types
#### Direct exchange type
In this exchange type the sender sends the message to the exhange using a routing key. A routing key is like a meta data attribute for the message. Any receiver who wants to get a message from an exhange needs to bind its queue to the exchange using a binding key. It is possible for sender to send the message directly to queue by using the default exchange type and using the routing key which is the same as the queue name.

#### Fanout exchange type
Fanout exchange provides a publish-subscribe pattern for messaging in RabbitMQ. Messages sent to an exchange with type as fanout are sent to all the queues that are bound to it irrespective of the routing key on the message.

#### Topic exchange type
A topic exchange type provides a means to send messages to queues which are based on pattern matching of the routing key. Various parts of a routing key needs to be delimited using a ‘.’ token. The binding key for the different queue bindings using a pattern matching based on the differnt parts of the routing key.

## Clean up
Run terraform:
```
$ terraform destroy
```
Don't forget you have to use the `-var-file` option when you run terraform destroy command to delete the aws resources created with extra variable files.
```
$ terraform destroy -var-file fixture.tc1.tfvars
```

## Additional Resources
* [RabbitMQ Tutorials](https://www.rabbitmq.com/getstarted.html)
* [Part 1: RabbitMQ Best Practices](https://www.cloudamqp.com/blog/part1-rabbitmq-best-practice.html)
* [Part 2: Best Practice for High Performance](https://www.cloudamqp.com/blog/part2-rabbitmq-best-practice-for-high-performance.html)
* [Part 3: Best Practice for High Availability](https://www.cloudamqp.com/blog/part3-rabbitmq-best-practice-for-high-availability.html)
* [Part 4: 13 Common RabbitMQ Mistakes](https://www.cloudamqp.com/blog/part4-rabbitmq-13-common-errors.html)
