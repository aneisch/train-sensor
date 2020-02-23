#!/bin/bash

# Monitor frequency and output to file
# Head of train: 452937500
# End of train: 457937500
rtl_fm -f $FREQUENCY -M fm -l $SQUELCH | xxd | tee -a output.txt >> /dev/null 2>&1 &

/script.sh &

while true; do
  cat
done
