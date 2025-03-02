#!/usr/bin/env bash

DPI=$(~/.local/bin/what-dpi.sh)
if [ "$DPI" -eq "192" ]; then
    echo "Switching to LowDPI (96)"
    xrdb -merge ~/.config/xsession/xsession.lowdpi
    xrandr -s 1920x1080
else
    echo "Switching to HiDPI (192)"
    xrdb -merge ~/.config/xsession/xsession.hidpi
    xrandr -s 3840x2160
fi
