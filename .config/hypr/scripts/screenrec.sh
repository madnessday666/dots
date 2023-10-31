#!/bin/bash
pid=`pgrep wf-recorder`
status=$?
dir='/home/madnessday666/Screenrecs/'

if [ $status != 0 ]
then
  notify-send -a "wf-recorder" "Screenrecord starts" -u low
  exec wf-recorder -c libx264rgb -F fps=120 -o DP-1 -f ~/Screenrecs/screenrec_$(date +%Y-%m-%dT%H-%M-%S).mp4 
else
  filename=$(ls -t $dir | head -1)
  notify-send -a "wf-recorder" "Screenrecord saved ${dir}${filename}" -u normal  
  pkill --signal SIGINT wf-recorder
fi;
