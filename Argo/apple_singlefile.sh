#!/bin/bash
echo "Copying file to S3 to simulate user upload"

i=$RANDOM
aws s3 cp apple_sample.mov s3://nautilus-video-init/apple_${i}.mov

#chmod u+x ./apple_singlefile.sh (command to run bash)