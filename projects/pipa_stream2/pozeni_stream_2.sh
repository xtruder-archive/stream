#!/bin/bash

#inicializacija vhoda na kartici
v4lctl -c /dev/video1 setattr input Composite1
v4lctl -c /dev/video0 setattr input Composite1

#ukaz ki začne prenos
gst-launch-0.10 \
	v4l2src device=/dev/video0 ! queue ! tee name=raw_dv_camera ! 'video/x-raw-yuv,format=(fourcc)I420,width=768,height=576,framerate=(fraction)25/1' ! tee name=raw_camera \
	v4l2src device=/dev/video1 ! queue ! 'video/x-raw-yuv,format=(fourcc)I420,width=768,height=576,framerate=(fraction)25/1' ! tee name=raw_camera2 \
	raw_camera. ! videoscale ! video/x-raw-yuv,width=592,height=444 ! videorate ! \
		video/x-raw-yuv,framerate=15/1 ! ffmpegcolorspace ! tee name=t_video1 \
        raw_camera2. ! videoscale ! video/x-raw-yuv,width=133,height=100 ! videorate ! \
		video/x-raw-yuv,framerate=15/1 ! ffmpegcolorspace ! tee name=t_video2 \
	filesrc location=logo.png ! pngdec ! alphacolor ! alpha method=0 alpha=1 ! ffmpegcolorspace ! videoscale ! video/x-raw-yuv,width=50,height=30 ! tee name=t_logo \
	alsasrc ! audio/x-raw-int,rate=44100,channels=1,depth=16 ! queue ! tee name=t_audio \
	videomixer name=pip sink_0::xpos=0 sink_0::ypos=0 sink_0::zorder=0 sink_1::xpos=449 sink_1::ypos=334 sink_1::alpha=0.8 sink_1::zorder=100 sink_2::xpos=532 sink_2::ypos=10 sink_2::zorder=100 sink_2::alpha=0.7 ! ffmpegcolorspace ! videoscale ! tee name=t_video \
	t_video1. ! queue ! pip.sink_0 \
	t_video2. ! queue ! pip.sink_1 \
	t_logo. ! queue ! pip.sink_2 \
	t_video. ! theoraenc quality=25 ! oggmux name=mux \
	t_audio. ! audioconvert ! vorbisenc ! queue ! mux. \
	mux. ! tee name=t_encoded \
	t_encoded. ! shout2send ip=dogbert port=8000 password=hackme mount=kiberpipa.ogg \
	raw_dv_camera. ! 'video/x-raw-yuv,format=(fourcc)Y41B,width=720,height=480' ! queue ! ffenc_dvvideo ! queue ! ffmux_dv name=t_dvmux \
	t_dvmux. ! queue ! filesink location=test2.dv
	

#t_encoded. ! queue ! filesink location=test.ogg \
#t_video1. ! queue ! xvimagesink sync=false \
#v4l2src ! queue ! videoscale ! video/x-raw-yuv,width=768,height=576 ! videorate ! video/x-raw-yuv,framerate=10/1 ! ffmpegcolorspace ! tee name=t_video1
#videotestsrc pattern="black"  ! video/x-raw-yuv,width=768,height=576 ! tee name=t_video1 \

