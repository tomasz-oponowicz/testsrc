#!/bin/sh

CODEC=$1 # aac

# Duration in seconds.
DURATION=60

ffmpeg \
  -f lavfi -i "sine=frequency=1:beep_factor=800:duration=${DURATION}" \
  -c:a $CODEC \
  -y audio.mp4
