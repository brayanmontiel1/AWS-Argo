#!/bin/bash
echo "Copying file to S3 to simulate user upload"

i=$RANDOM
aws s3 cp apple_sample.mov s3://nautilus-video-init-london/apple_${i}.mov