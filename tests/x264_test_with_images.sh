#!/bin/bash

#ukaz ki začne prenos
gst-launch-0.10 \
	v4l2src device=/dev/video1 ! queue ! ffmpegcolorspace ! tee name=raw_camera \
	v4l2src device=/dev/video0 ! queue ! jpegdec ! ffmpegcolorspace ! tee name=raw_camera2 \
	raw_camera. ! videorate ! \
		video/x-raw-yuv,framerate=15/1 ! tee name=t_video1 \
        raw_camera2. ! videoscale ! video/x-raw-yuv,width=133,height=100 ! videorate ! \
		video/x-raw-yuv,framerate=15/1 ! tee name=t_video2 \
	multifilesrc location="logo.png" caps="image/png,framerate=1/1" ! pngdec ! alpha method=0 alpha=1 ! ffmpegcolorspace ! videoscale ! video/x-raw-yuv,width=100,height=30 ! tee name=t_logo \
	videomixer name=pip sink_0::xpos=0 sink_0::ypos=0 sink_0::zorder=0 sink_1::xpos=449 sink_1::ypos=334 sink_1::alpha=0.8 sink_1::zorder=100 sink_2::xpos=532 sink_2::ypos=10 sink_2::zorder=100 sink_2::alpha=0.7 ! ffmpegcolorspace ! videoscale ! tee name=t_video \
	alsasrc device=hw:0,0 ! queue ! audio/x-raw-int,rate=44100,depth=16,channels=2,signed=true,endianness=1234 ! tee name=t_audio \
	t_video1. ! queue ! pip.sink_0 \
	t_video2. ! queue ! pip.sink_1 \
	t_logo. ! queue ! pip.sink_2 \
	t_video. ! queue ! x264enc profile=1 tune=0x00000001 bitrate=600 ! avimux name=mux ! queue ! filesink location=test.avi sync=false \
	t_audio. ! audioconvert ! queue ! alawenc ! mux. \
	t_video1. ! queue ! videorate ! video/x-raw-yuv,framerate=1/1 ! ffmpegcolorspace ! pngenc compression-level=1 snapshot=false ! queue ! multifilesink location=output-%05d.png sync=false

#t_encoded. ! queue ! filesink location=test.ogg \
#t_video1. ! queue ! xvimagesink sync=false \
#v4l2src ! queue ! videoscale ! video/x-raw-yuv,width=768,height=576 ! videorate ! video/x-raw-yuv,framerate=10/1 ! ffmpegcolorspace ! tee name=t_video1
#videotestsrc pattern="black"  ! video/x-raw-yuv,width=768,height=576 ! tee name=t_video1 \

