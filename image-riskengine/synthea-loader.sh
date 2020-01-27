#!/bin/bash

rm -rf output

if [ -z "$1" ];
then
    numberOfPatients=5000
else
    numberOfPatients=$1
fi

docker run --rm -v $PWD/output:/output --name synthea-docker intersystemsdc/irisdemo-base-synthea:readmission-demo -p $numberOfPatients -s 1577991349289

tar -czvf ./patient-data.tar.gz ./output

rm -rf output
