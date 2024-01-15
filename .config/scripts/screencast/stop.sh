#!bin/bash

dir="$(dirname "$(readlink -f "$0")")"
cd $dir && echo 'q' > stop && rm stop

exit
