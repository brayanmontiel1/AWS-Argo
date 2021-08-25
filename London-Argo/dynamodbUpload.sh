#!/bin/bash
echo "uploadig to DynamoDB"

i=$RANDOM
#NOW = current date 
DATER=$(date "+%m-%d-%Y")
TIMER=$(date -u +"%H:%M:%S")

#uploading data to DynamoDB (Works)
aws dynamodb put-item \
    --table-name argo-videos-london \
    --item '{
        "VideoTitles": {"S": "'$i'"},
        "DateCompleted": {"S": "'$DATER'"},
        "TimeCompleted": {"S": "'$TIMER'"}
      }' \
    --return-consumed-capacity TOTAL


