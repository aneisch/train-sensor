FROM alpine:latest

RUN apk add --no-cache --update libusb-dev bash mosquitto-clients
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing librtlsdr-dev rtl-sdr

COPY script.sh /script.sh
COPY start.sh /start.sh

RUN chmod +x /script.sh
RUN chmod +x /start.sh
RUN adduser -D train_sensor

USER train_sensor

ENV DEVICE_INDEX=0
ENV FREQUENCY 452937500
ENV SQUELCH 120
ENV MQTT_HOST 10.0.1.22
ENV MQTT_PORT 1883
ENV MQTT_TOPIC sensor/train
ENV HOLDOFF_TIME 600

ENTRYPOINT ["/start.sh"]
