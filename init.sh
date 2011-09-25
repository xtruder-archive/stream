#!/bin/bash
git submodule init

function gstreamer {
    git submodule update streamers/gstreamer/*
    cd streamers/gstreamer
    ./build_all.sh
    cd ../../
}

echo $1
$1
