#!/bin/sh

SIZE=$1       # 1920x1080
FRAME_RATE=$2 # 24
CODEC=$3      # h264
PROFILE=$4    # high
LEVEL=$5      # 4.2
BITRATE=$6    # 600k

# Transforms size to scale. For example 1920x1080 to 1080.
SCALE=$(echo $1 | cut -d'x' -f 2)

ffmpeg -i input.mp4 \
  -vf "drawtext=\
          fontfile=LiberationMono-Regular.ttf: \
          text='s=${SIZE} c=${CODEC} p=${PROFILE} l=${LEVEL}': \
          r=${FRAME_RATE}: \
          x=10: \
          y=10: \
          fontcolor=white: \
          fontsize=64: \
          box=1: \
          boxcolor=0x00000099, \
       scale=-2:${SCALE}" \
  -c:v libx264 -profile:v $PROFILE -level:v $LEVEL \
  -x264-params scenecut=0:open_gop=0:min-keyint=72:keyint=72 \
  -minrate $BITRATE -maxrate $BITRATE -bufsize $BITRATE -b:v $BITRATE \
  -y "${SCALE}.mp4"
