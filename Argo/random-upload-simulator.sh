#!/bin/bash

#SCRIPT SIMULATES RANDOM USER UPLOADS TO US_OREGON and EU_LONDON Regions.
for i in {1..50}
do
    b=$RANDOM
    if (( b % 2 == 0 )) #will decide which region to upload to.
    then #oregon : us-west-2
        i=$RANDOM
        if (( i % 2 == 0 )) #random assign android or apple upload
        then
            echo "Simulating iOS upload to Oregon region"
            aws s3 cp apple_sample.mov s3://nautilus-video-init/apple_${i}.mov #apple upload
        else
            echo "Simulating iOS upload to Oregon region"
            aws s3 cp android_sample.3gp s3://nautilus-video-init/android_${i}.3gp #android upload
        fi
    else #london: eu-west-2
        i=$RANDOM
        if (( i % 2 == 0 )) #random assign android or apple upload
        then
            echo "Simulating iOS upload to London region"
            aws s3 cp apple_sample.mov s3://nautilus-video-init-london/apple_${i}.mov #apple upload
        else
            echo "Simulating Android upload to London region"
            aws s3 cp android_sample.3gp s3://nautilus-video-init-london/android_${i}.3gp #android upload
        fi
    fi
done



#chmod u+x ./apple_singlefile.sh (command to run bash)