# RgbLedCtl
RgbLedCtl is an electronic unit and application for controlling RGB led. Communication with the electronic unit is carried out via WiFi.
Based on ESP8266 WiFi SOC with NodeMCU firmware.

The project consists of an electrical unit, lua scripts for ESP8266 and RGBLed -
 control applications.

# Principle of operation
After switching on, the unit is connected to the specified WiFi point. The client (RGBLed) connects to it on the tcp socket. The client sends commands - a color in the form of HEX RGB. The MCU generates the corresponding PWM signals to the keys.

# Electrical scheme
Electrical scheme - project for KiCad. Input power supply 12V. With the help of DC-DK 12v is converted into 5v. whis a linear regulator LM1113 converted 5v to 3.3v. 5v are needed to connect an additional control panel (will be added in the next versions). MOSFETs are used as keys.

# ESP8266 firmware
NodeMCU is used as the firmware. The site of the project http://nodemcu.com/index_en.html. Instructions for the flash firmware https://nodemcu.readthedocs.io/en/master/en/flash/.
After the flash, you need to load lua scripts (from the folder McuScripts) in the MCU. For load scripts recommend using the utility ESPlorer - https://github.com/4refr0nt/ESPlorer.
Before load scripts, rename config.lua.example to config.lua and enter the parameters of your WiFi into it.

# RGBLed
RGBLed - application for control backlight. This is a cross-platform application written using Qt5. The interface is written in QML. The application source code is located in the RGBLed directory as a project for QtCreator.
Qt libraries and theirs source code, as well as QtCreator, can be found on the official Qt website - https://www.qt.io/
Link to the download page Qt5 https://www.qt.io/download-open-source/