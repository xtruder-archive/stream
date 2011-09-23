#!/bin/bash
for i in gstreamer gnonlin gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-python gst-ffmpeg
do
    git submodule add git://anongit.freedesktop.org/gstreamer/$i gstreamer/$i
done

