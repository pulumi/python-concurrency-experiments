import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";

const bucket = new aws.s3.Bucket("bucket", {
    acl: "private",
    tags: {
        Environment: "Dev",
        Name: "My bucket",
    },
});