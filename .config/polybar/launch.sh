#!/usr/bin/env sh

# Terminate already running bar instances
pkill polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bars
sleep 0.1

polybar -q TopLeft -r &

sleep 0.1

polybar -q TopCenter -r &

sleep 0.1

polybar -q TopRight -r &

sleep 0.1
