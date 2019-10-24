#!/bin/sh

DURATION=$1	# 60
CODEC=$2	# aac

ffmpeg \
  -f lavfi -i "sine=frequency=1:beep_factor=800:duration=${DURATION}" \
  -c:a $CODEC \
  -y audio.mp4
