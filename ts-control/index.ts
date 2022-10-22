import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";

// SQS
[...Array(100)].map((_, i) => {
  const name = `pulumi-${i}`;
  new aws.sqs.Queue(name);
});

// SNS
[...Array(100)].map((_, i) => {
  const name = `pulumi-${i}`;
  new aws.sns.Topic(name);
});
