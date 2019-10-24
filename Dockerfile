FROM jrottenberg/ffmpeg:4.2-alpine as ffmpeg
WORKDIR /build
COPY audio.sh /build
RUN /build/audio.sh 60 aac
COPY input.sh video.sh LiberationMono-Regular.ttf /build/
RUN /build/input.sh 1920x1080 24 60
RUN /build/video.sh 640x360 24 h264 baseline 3.0 60k
RUN /build/video.sh 854x480 24 h264 main 3.1 100k
RUN /build/video.sh 1280x720 24 h264 main 4.0 300k
RUN /build/video.sh 1920x1080 24 h264 high 4.2 600k
RUN rm input.mp4

FROM google/shaka-packager:release-v2.3.0 as shaka
WORKDIR /build
COPY --from=ffmpeg /build/*.mp4 /build/
RUN packager \
	'in=audio.mp4,stream=audio,init_segment=aac/init.mp4,segment_template=aac/$Number$.m4s' \
	'in=360.mp4,stream=video,init_segment=h264_360/init.mp4,segment_template=h264_360/$Number$.m4s' \
	'in=480.mp4,stream=video,init_segment=h264_480/init.mp4,segment_template=h264_480/$Number$.m4s' \
	'in=720.mp4,stream=video,init_segment=h264_720/init.mp4,segment_template=h264_720/$Number$.m4s' \
	'in=1080.mp4,stream=video,init_segment=h264_1080/init.mp4,segment_template=h264_1080/$Number$.m4s' \
	--segment_duration 3 --generate_static_mpd --mpd_output manifest.mpd
RUN rm *.mp4

FROM alpine:3.10.3
WORKDIR /srv
RUN apk add --no-cache python3 vim
COPY server.py /srv
COPY --from=shaka /build /srv
CMD python3 server.py