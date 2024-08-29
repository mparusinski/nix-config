#!/usr/bin/env bash
xdpyinfo | grep dots | tr -s ' ' | cut -d ' ' -f 3 | cut -d 'x' -f 1
