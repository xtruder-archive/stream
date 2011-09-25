#!/bin/bash
echo "Build start."
for i in gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-python gst-ffmpeg
do
    ./gst-head echo "Compiling $i"
    cd $i
    ./autogen.sh
    make
    cd ..
done
