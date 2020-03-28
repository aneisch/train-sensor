FROM alpine:latest

RUN apk add --no-cache --update libusb-dev bash mosquitto-clients

RUN apk add --no-cache --virtual build-deps alpine-sdk gcc build-base cmake git && \
    mkdir /tmp/src && \
    cd /tmp/src && \
    git clone https://github.com/steve-m/librtlsdr.git && \
    mv librtlsdr rtl-sdr && \
    mkdir /tmp/src/rtl-sdr/build && \
    cd /tmp/src/rtl-sdr/build && \
    cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON -DCMAKE_INSTALL_PREFIX:PATH=/usr/local && \
    make && \
    make install && \
    chmod +s /usr/local/bin/rtl_* && \
    cd /tmp/src/ && \
    git clone https://github.com/merbanan/rtl_433 && \
    cd rtl_433/ && \
    mkdir build && \
    cd build && \
    cmake ../ && \
    make && \
    make install && \
    apk del build-deps && \
    rm -r /tmp/src

COPY script.sh /script.sh
COPY start.sh /start.sh

RUN chmod +x /script.sh
RUN chmod +x /start.sh

ENV LD_LIBRARY_PATH=/usr/local/lib64/
ENV DEVICE_INDEX=0
ENV FREQUENCY 452937500
ENV SQUELCH 120
ENV MQTT_HOST 10.0.1.22
ENV MQTT_PORT 1883
ENV MQTT_TOPIC sensor/train
ENV HOLDOFF_TIME 600

ENTRYPOINT ["/start.sh"]
