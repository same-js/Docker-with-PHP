#!bin/bash

echo "---------------------------------"
awslocal --version
echo "---------------------------------"

source /docker-entrypoint-initaws.d/.env

# create S3 bucket
awslocal s3api create-bucket --bucket $bucketName --create-bucket-configuration LocationConstraint=ap-northeast-1
awslocal s3 sync /docker-entrypoint-initaws.d/s3 s3://$bucketName --acl public-read

# create SQS queue
awslocal sqs create-queue --queue-name $queueName --attributes file:///docker-entrypoint-initaws.d/sqs/create-queue.json

# for debug
# awslocal s3 ls
# awslocal s3 ls s3://$bucketName
# awslocal sqs list-queues