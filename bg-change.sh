#!/bin/bash

# This script automatically changes the desktop background for KDE based on the time of day. 
# It cycles through images found in a specified directory, selecting one that corresponds 
# to different time periods: Morning, Day, Sunset, and Night.
# 
# Image Naming Convention: 
# To ensure the script functions correctly, images must be named in the following format:
#   - For Morning: `bg-change_Morning_*.jpg`
#   - For Day: `bg-change_Day_*.jpg`
#   - For Sunset: `bg-change_Sunset_*.jpg`
#   - For Night: `bg-change_Night_*.jpg`

# Folder with images
DIR="INSERT PATH HERE"
SLEEP=300

FILES=$(find $DIR -type f | grep XPP | sort)

# Set background on kde
setBackground()
{
  FILE=$(echo "$FILES" | grep "bg-change_$1_" | grep -v NoMoon | shuf -n 1)
  echo "BG-CHANGE: Set new background: $FILE"

  plasma-apply-wallpaperimage $FILE
}

while true; do

  HOUR=$(date +%H)

  if test $HOUR -gt 20 -o $HOUR -le 5; then
    setBackground "Night"
  elif test $HOUR -gt 17; then
    setBackground "Sunset"
  elif test $HOUR -gt 10; then
    setBackground "Day"
  elif test $HOUR -gt 7; then
    setBackground "Morning"
  elif test $HOUR -gt 5; then
    setBackground "Sunrise"
  fi
  
  sleep $(SLEEP)
done
