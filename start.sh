#!/bin/bash

# Monitor frequency and output to file
# Head of train: 452937500
# End of train: 457937500
rtl_fm -f $FREQUENCY -M fm -l $SQUELCH -g -4 | xxd | tee -a output.txt >> /dev/null &

/script.sh &

# Make the script stay "running"
while true; do :; done & kill -STOP $! && wait $!
