#!/bin/bash
killall -q polybar
while pgrep -x polybar >/dev/null; do sleep 0.1; done
polybar --reload example &
