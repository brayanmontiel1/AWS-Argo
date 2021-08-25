#!/bin/bash
echo "Copying file to S3 to simulate user upload"

i=$RANDOM
aws s3 cp android_sample.3gp s3://nautilus-video-init/andriod_${i}.3gp