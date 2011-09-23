#!/usr/bin/python
import gobject; gobject.threads_init()
import pygst; pygst.require("0.10")
import gst
import time

p = gst.parse_launch ("""videomixer name=mix sink_0::width=50 sink_0::height=50 sink_1::width=100 sink_1::height=100 ! ffmpegcolorspace ! xvimagesink
v4l2src ! queue ! ffmpegcolorspace ! video/x-raw-rgb, width=640, height=480 ! mix.sink_0
videotestsrc name=src ! video/x-raw-rgb, framerate=15/1, width=640, height=360 ! freeze max_buffers=0 ! mix.sink_1
""")

m = p.get_by_name ("mix")
s0 = m.get_pad ("sink_0")
s1 = m.get_pad ("sink_1")
#s0.set_property ("xpos", 200)

src = p.get_by_name("src")
srcp0 = src.get_pad("src")

zero= p.get_clock().get_time()
print "Zero time ", zero
p.set_state (gst.STATE_PLAYING)

while(1):
    var= raw_input("what you want to animate?")
    time= (p.get_clock().get_time()-zero)/1000000000
    print time
    if var=="l":
        control = gst.Controller(s0, "width", "height", "alpha")
        control.set_interpolation_mode("width", gst.INTERPOLATE_LINEAR)
        control.set_interpolation_mode("height", gst.INTERPOLATE_LINEAR)
        control.set_interpolation_mode("alpha", gst.INTERPOLATE_LINEAR)
        control.set("width", time * gst.SECOND, 50) 
        control.set("width", (time+5) * gst.SECOND, 640)
        control.set("height", time * gst.SECOND, 50)
        control.set("height", (time+5) * gst.SECOND, 480)
        s1=m.get_request_pad("sink_1")
        s1.set_property("width",100)
        s1.set_property("height",100)
        srcp0= src.get_pad("src")
        srcp0.link(s1)
        src.set_state(gst.STATE_PLAYING)
        p.set_state(gst.STATE_PLAYING)
    if var=="r":
        control = gst.Controller(s0, "width", "height")
        control.set_interpolation_mode("width", gst.INTERPOLATE_LINEAR)
        control.set_interpolation_mode("height", gst.INTERPOLATE_LINEAR)
        control.set("width", time * gst.SECOND,640) 
        control.set("width", (time+5) * gst.SECOND, 50)
        control.set("height", time * gst.SECOND, 480)
        control.set("height", (time+5) * gst.SECOND, 50)
        src.set_state(gst.STATE_PAUSED)
