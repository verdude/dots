#!/usr/bin/env bash

polybar-msg cmd quit
# killall -q polybar

echo "---" | tee -a /tmp/polybar1.log
polybar bar1 2>&1 | tee -a /tmp/polybar1.log & disown
echo "Polybar launched..."
