#!/bin/bash

# Monitor changes in count of output file
# publish to mqtt when detection occurs

# Monitor frequency and output to file
# Head of train: 452937500
# End of train: 457937500
rtl_fm -f $FREQUENCY -M fm -l $SQUELCH -g -4 | xxd | tee -a output.txt >> /dev/null &

ORIG_SIZE=$(wc -l /output.txt | cut -f1 -d' ')

while true; do
  CUR_SIZE=$(wc -l /output.txt | cut -f1 -d' ')
  if [ "$ORIG_SIZE" == "$CUR_SIZE" ]; then
    sleep 30
  else
    mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_TOPIC -m 1
    pkill rtl_fm
    sleep $HOLDOFF_TIME
    rtl_fm -f $FREQUENCY -M fm -l $SQUELCH -g -4 | xxd | tee -a output.txt >> /dev/null &
    sleep 1
    echo > output.txt
    ORIG_SIZE=$(wc -l /output.txt | cut -f1 -d' ')
  fi
done
