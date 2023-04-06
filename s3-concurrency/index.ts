import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";

const config = new pulumi.Config();

const resourceCount: number = config.requireNumber("resource_count");
const count = resourceCount / 2;

// SQS
[...Array(count)].map((_, i) => {
  const name = `pulumi-${i}`;
  new aws.sqs.Queue(name);
});

// SNS
[...Array(count)].map((_, i) => {
  const name = `pulumi-${i}`;
  new aws.sns.Topic(name);
});
