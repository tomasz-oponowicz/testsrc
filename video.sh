#!/bin/sh

SIZE=$1     # 1920x1080
CODEC=$2    # h264
PROFILE=$3	# high
LEVEL=$4    # 4.2
BITRATE=$5	# 600k

# Transforms size to scale. For example 1920x1080 to 1080.
SCALE=$(echo $1 | cut -d'x' -f 2)

# Original quality
ORIGINAL_SIZE=1920x1080

# Duration in seconds.
DURATION=60

# Rate in frames per second.
RATE=24

ffmpeg \
  -f lavfi -i "testsrc=duration=${DURATION}:size=${ORIGINAL_SIZE}:rate=${RATE}" \
  -vf "drawtext=fontfile=LiberationMono-Regular.ttf: \
       text='s=${SIZE} c=${CODEC} p=${PROFILE} l=${LEVEL}': r=${RATE}: x=10: y=10: fontcolor=white: \
       fontsize=64: box=1: boxcolor=0x00000099" \
  -pix_fmt yuv420p \
  -y original.mp4

ffmpeg -i original.mp4 \
  -vf "scale=-2:${SCALE}" \
  -c:v libx264 -profile:v $PROFILE -level:v $LEVEL \
  -x264-params scenecut=0:open_gop=0:min-keyint=72:keyint=72 \
  -minrate $BITRATE -maxrate $BITRATE -bufsize $BITRATE -b:v $BITRATE \
  -y "${SCALE}.mp4"

 rm -f original.mp4