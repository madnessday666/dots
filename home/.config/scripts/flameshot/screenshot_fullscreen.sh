#!/bin/bash


flameshot gui --region "$(xrandr --query --listactivemonitors \
                         | grep ' connected ' \
                         | sed -E 's/( connected)|( primary)|(\(.+)|( left)//g' \
                         | cut -d ' ' -f2)" -p $HOME/Screenshots
exit
