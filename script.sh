#!/bin/bash

# Monitor changes in count of output file
# publish to mqtt when detection occurs

ORIG_SIZE=$(wc -l /output.txt | cut -f1 -d' ')

while true; do
  CUR_SIZE=$(wc -l /output.txt | cut -f1 -d' ')
  if [ "$ORIG_SIZE" == "$CUR_SIZE" ]; then
    sleep 30
  else
    mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_TOPIC -m 1
    sleep $HOLDOFF_TIME
    echo > output.txt
    ORIG_SIZE=$(wc -l /output.txt | cut -f1 -d' ')
  fi
done
