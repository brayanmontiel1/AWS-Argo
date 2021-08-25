#!/bin/bash
#$1 reference aws batch parameter passed from job definition command : 
#/tmp/workdir/transcode-runner.sh Ref::inputfile

#downloads inputfile from s3 bucket : nautilus-video-init to current directory
aws s3 cp s3://nautilus-video-init/$1 .

#variables
name=$(echo $1 | cut -f 1 -d '.') #name = inputfile name only
DATER=$(date "+%m-%d-%Y")
TIMER=$(date -u +"%H:%M:%S")


#ffmpeg converts video to .mp4
ffmpeg -i $1 -c:v libx264 -c:a aac -movflags +faststart $name.mp4
#upload video to s3 bucket: nautilus-final
aws s3 cp $name.mp4 s3://nautilus-final/$name.mp4

#uploads name of video and date to DynamoDB for record keeping
aws dynamodb put-item \
    --table-name argo-videos \
    --item '{
        "VideoTitles": {"S": "'$name'.mp4"},
        "DateCompleted": {"S": "'$DATER'"},
        "TimeCompleted": {"S": "'$TIMER'"}
      }' \
    --return-consumed-capacity TOTAL

#removes inputfile from nautilus-video-init bucket (raw upload)
aws s3 rm s3://nautilus-video-init/$1

