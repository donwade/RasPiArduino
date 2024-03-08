#!/bin/bash

# used for uploading an arduino raspi build onto the h/w target.

PI_HOST=$1
NOT_USED_PI_PORT=$2
NOT_USED_PI_PASS=$3
PI_FILE=$4

CYAN "PI_HOST= $PI_HOST"
CYAN "PI_FILE= $PI_FILE"
CYAN "\$2 (not used ... port) = $2"
CYAN "\$3 (not used ... unkn) = $3"


rm /tmp/sketch.bin

cp $PI_FILE /tmp/sketch.bin
touch /tmp/sketch.bin

GREEN "copying /tmp/sketch.bin to $1"
rsync  /tmp/sketch.bin dwade@$PI_HOST:/tmp/sketch.bin

GREEN "/tmp/sketch.bin as seen on $1"
ssh dwade@$PI_HOST 'ls -al /tmp/sketch.bin'
echo

GREEN "running merge-sketch-with-bootloader.lua on $1"

ssh dwade@$PI_HOST '/usr/local/bin/merge-sketch-with-bootloader.lua'

RED "running run-avrdude on $1"
ssh -X dwade@$PI_HOST 'xterm -fa 'Monospace' -fs 14  /usr/local/bin/run-avrdude' # #| tee /tmp/run-avrdude.log'
sleep 2

ssh dwade@$PI_HOST 'cat /tmp/run-avrdude.log'
ssh dwade@$PI_HOST 'ps -ef | grep arduino-sketch'

GREEN "end of running $0 "
GREEN "`date`"
sleep 10
