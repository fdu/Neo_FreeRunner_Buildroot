# Linux system build for the Neo FreeRunner with Buildroot

This project is a set of patches and configuration files for [Buildroot](https://buildroot.org/) to build a Linux system image with a minimal root file system for the great [Openmoko Neo FreeRunner (GTA02)](http://wiki.openmoko.org/wiki/Neo_FreeRunner).

## Build

The first step is to get the files required to run Buildroot:

```
$ make bootstrap
```

Then build the images with:

```
$ make build
```

After the build, the directory `buildroot/output/images/` contains 
 - the kernel image for U-Boot `uImage`
 - the JFFS2 root file system for the NAND `rootfs.jffs2`

## Run

### From the internal flash

The images can be flashed with dfu-util by following with standard [Neo FreeRunner flashing instructions](http://wiki.openmoko.org/wiki/Flashing_the_Neo_FreeRunner) or by using:

```
$ make flash_kernel
$ make flash_rootfs
```

### From a SD card

The SD card partitioning is described [Booting the Neo FreeRunner from SD via U-Boot](http://wiki.openmoko.org/wiki/Booting_the_Neo_FreeRunner_from_SD_via_U-Boot).

The kernel must be copied from `buildroot/output/images/uImage` to the first SD card partition (FAT) under the name `uImage.bin`. The content of the root file system archive `buildroot/output/images/rootfs.tar.gz` must be extracted in the second SD card partition (ext3).

## Configure

### Packages

The image content can be configured in Buildroot with:

```
$ make -C buildroot/ menuconfig
```

### Network

The IP configuration for the USB gadget ethernet interface resides in `overlay/etc/network/interfaces`. A custom SSID and PSK for the wifi can be added in `overlay/etc/wpa_supplicant.conf`.

## Support

:heavy_check_mark: Build kernel

:heavy_check_mark: Build root file system (JFFS2 in flash)

:heavy_check_mark: Build root file system (SD card)

:x: Build boot loader

:heavy_check_mark: Display (console in frame buffer `/dev/fb0`)

:heavy_check_mark: Display (Xorg with `xdriver_xf86-video-fbdev`, tested with fluxbox)

:heavy_check_mark: Touch screen (`/dev/input/mouse0` output, also working under Xorg)

:heavy_check_mark: Backlight control

:question: USB host

:heavy_check_mark: USB gadget (Ethernet)

:heavy_check_mark: Wifi (WPA2/PSK)

:question: Bluetooth

:heavy_plus_sign: GPS (NMEA messages coming on `/dev/s3c2410_serial1`, no fix)

:question: SD card

:question: 3D accelerometers

:heavy_check_mark: LEDs

:question: GPRS

:heavy_check_mark: Buttons (AUX on `/dev/input/event0`, power on `/dev/input/event2`)

:heavy_plus_sign: Device power management (wifi, others not tested)

:question: Suspend / resume

:question: Watchdog

:question: Real-time clock

:question: Audio on jack

:question: Audio on speaker

:question: Microphone

## Changelog

* next
  * Buildroot 2019.02
  * Linux 2.6.37
  * GCC 4.9.4
  * Added [omhacks](https://github.com/radekp/omhacks)
  * Added network configuration for usb0 and eth0
  * Fixed dependencies for Xorg and fluxbox window manager
* 0.2
  * Buildroot 2020.02
  * Linux 3.2.99
  * GCC 5.5.0
* 0.1
  * Buildroot 2019.02
  * Linux 2.6.37
  * GCC 4.9.4
