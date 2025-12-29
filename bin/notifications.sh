#!/bin/bash

if $(dunstctl is-paused);
then
    echo %{F#7f849c}%{F-}
else
    echo %{F#f9e2af}%{F-}
fi
