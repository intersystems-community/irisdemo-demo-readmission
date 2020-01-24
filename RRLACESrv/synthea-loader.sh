#!/bin/bash

rm -rf output

docker run --rm -v $PWD/output:/output --name synthea-docker intersystemsdc/irisdemo-base-synthea:readmission-demo -p 5000 -s 1577991349289

tar -czvf ./patient-data.tar.gz ./output

rm -rf output
