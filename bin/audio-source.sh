#!/bin/bash

echo $(wpctl status | grep '*' | awk '{print $4}' | head -n 1)
