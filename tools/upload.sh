#!/bin/bash

# used for uploading an arduino raspi build onto the h/w target.

PI_HOST=$1
NOT_USED_PI_PORT=$2
NOT_USED_PI_PASS=$3
PI_FILE=$4

rm /tmp/sketch.bin

cp $PI_FILE /tmp/sketch.bin
touch /tmp/sketch.bin
rsync /tmp/sketch.bin dwade@$PI_HOST:/tmp/sketch.bin

ssh dwade@$PI_HOST 'ls -al /tmp/sketch.bin'
echo

ssh dwade@$PI_HOST '/usr/local/bin/merge-sketch-with-bootloader.lua'
ssh dwade@$PI_HOST '/usr/local/bin/run-avrdude'

