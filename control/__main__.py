"""An AWS Python Pulumi program"""
import pulumi
import pulumi_aws as aws

# SQS
for i in range(100):
    name = f'pulumi-{str(i).rjust(3,"0")}'
    aws.sqs.Queue(
        name
    )
    
# SNS
for i in range(100):
    name = f'pulumi-{str(i).rjust(3,"0")}'
    aws.sns.Topic(
        name
    )