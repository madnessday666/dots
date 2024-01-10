#!/usr/bin/env sh

# Terminate already running bar and compositor instances
pkill polybar && pkill compfy

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bars
polybar -q TopLeft -r &
polybar -q TopRight -r &
polybar -q TopCenter -r &

sleep 0.1
