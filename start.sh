#!/bin/bash

/script.sh &

# Make the script stay "running"
while true; do :; done & kill -STOP $! && wait $!
