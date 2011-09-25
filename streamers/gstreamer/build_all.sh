#!/bin/bash
for i in gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-python gst-ffmpeg
do
	cd $i
	./autogen.sh
	make
	cd ..
done
