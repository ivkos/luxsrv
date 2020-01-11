# luxsrv
❤️💚💙

**luxsrv** is a Lua program for the NodeMCU ESP8266 devkit that listens for 
network packets describing the color setup and driving the WS2812B LED strip.

**luxsrv** is part of **[Lux](https://github.com/ivkos/lux)**.

## NodeMCU
Refer to these resources for more details:
* [NodeMCU Overview](https://nodemcu.readthedocs.io/en/master/)
* [NodeMCU Getting Started](https://nodemcu.readthedocs.io/en/master/getting-started/)

## Firmware
The NodeMCU ESP8266 devkit must have the NodeMCU firmware flashed on it. 
Refer to the following resources for instructions how to flash it:

* Building the NodeMCU firmware:
  - [Reference](https://nodemcu.readthedocs.io/en/master/build/)
  - [NodeMCU Custom Builds](https://nodemcu-build.com/) - Cloud Build Service
* Flashing the NodeMCU firmware:
  - [Reference](https://nodemcu.readthedocs.io/en/master/flash/)
  - [NodeMCU PyFlasher](https://github.com/marcelstoer/nodemcu-pyflasher)

## Development

### Requirements
* Node.js (required by [NodeMCU-Tool](https://github.com/andidittrich/NodeMCU-Tool))

### Installing
Run **`npm install`** to install the dependencies.

### Configuration
#### Wi-Fi Configuration
Wi-Fi credentials must reside in `src/wifi_config.lua` following this format:
```lua
return {
    WIFI_SSID = "My Home Network",
    WIFI_PSK = "MySuperSecretPassword"
}
```

#### LED Pixel Count
Set the number of pixels on your LED strip in `src/lux_server.lua`, e.g.:
```lua
local LED_COUNT = 120
local PORT = 42170
```

### Uploading the Scripts
- Connect the ESP8266 to your PC via its microUSB port.
- To list what's on the device, run **`npm run ls`**
- To format the device, run **`npm run format`**
- Compile and upload with **`npm run upload`**
