# Train Sensor
<a href="https://www.buymeacoffee.com/aneisch" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-black.png" width="150px" height="35px" alt="Buy Me A Coffee" style="height: 35px !important;width: 150px !important;" ></a><br>

Uses [RTL_FM](http://kmkeen.com/rtl-demod-guide/2013-01-02-17-54-37-499.html) and SDR to detect passing locomotives [end of train device (EOTD)](https://www.sigidwiki.com/wiki/End_of_Train_Device_(EOTD)) and publish messages to 
MQTT. Monitors head of train at `452.9375`MHz by default. You can tune to `457.9375`MHz for end of train detection. 

Optimum squelch value will vary greatly based on antenna, distance from locomotive, etc. Once the container is running, for the initial squelch tuning I recommend using `docker exec -it tcontainer_name /bin/bash`, executing `pkill rtl_fm` inside the container and manually running `rtl_fm -f $FREQUENCY -M fm -l $SQUELCH`. Lower the squelch value until you begin picking up noise, and then raise it slightly to suppress the noise again. This will be a good starting point!

https://hub.docker.com/r/aneisch/train-sensor

## Usage

### Example docker-compose:

```yaml
version: '3.2'
services:
    train-sensor:
        container_name: train-sensor
        image: aneisch/train-sensor
        restart: 'on-failure'
        devices:
            - '/dev/rtl_sdr:/dev/bus/usb/001/005'
        environment:
            - SQUELCH=90
```

### Example `docker run`:
```bash
docker run -d --name train-sensor --device='/dev/rtl_sdr:/dev/bus/usb/001/005' \
-e SQUELCH=90 aneisch/train-sensor
```

### Environmental Variables
You only need to specify the environmental variables in `docker run` or your docker-compose file that you want/need to override:

variable | default | description
-- | -- | --
`FREQUENCY` | 452.9375 | MQTT server address
`SQUELCH` | 120 | Squelch level
`MQTT_HOST` | 10.0.1.22 | MQTT server address/hostname
`MQTT_PORT` | 1883 | MQTT server port (non-ssl)
`MQTT_TOPIC` | sensor/train | Topic where train detection will be published. Publishes `1` when detected.
`HOLDOFF_TIME` | 600 | Time in seconds to prevent trigger after a detection
