#!/usr/bin/env bash

xdotool getactivewindow && xdotool keydown $1 && xdotool keyup $1
