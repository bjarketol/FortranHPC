#!/bin/bash

time ./main.exe
python visualize.py

cd fig/
ffmpeg -framerate 10 -pattern_type glob -i '*.jpg' -y out.avi
vlc --play-and-exit out.avi
cd ../


