#!/bin/bash

if [ $(wpctl status | grep '*' | awk '{print $4}' | head -n 1) == 'G433' ]
then
    wpctl set-default $(wpctl status | grep "Starship/Matisse HD Audio Controller Analog Stereo" | awk '{print $2}' | head -n 1)
else
    wpctl set-default $(wpctl status | grep "G433 Gaming Headset Analog Stereo" | awk '{print $2}' | head -n 1)
fi
