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

# Command: pulumi up --tracing http://localhost:9411/api/v1/spans --skip-preview --yes
# run 1: 3m18s
# run 2: 3m16s
# run 3: 3m17s