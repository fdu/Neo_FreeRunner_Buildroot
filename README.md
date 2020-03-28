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
 - the U-Boot image `u-boot.udfu`
 - the Linux kernel image for U-Boot `uImage`
 - the JFFS2 root file system for the NAND `rootfs.jffs2`

## Flash the system

### Internal NAND flash

The images can be flashed with dfu-util by following with standard [Neo FreeRunner flashing instructions](http://wiki.openmoko.org/wiki/Flashing_the_Neo_FreeRunner) or by using:

```
$ make flash
```

### SD card

The SD card partitioning is described in [Booting the Neo FreeRunner from SD via U-Boot](http://wiki.openmoko.org/wiki/Booting_the_Neo_FreeRunner_from_SD_via_U-Boot).

The kernel must be copied from `buildroot/output/images/uImage` to the first SD card partition (FAT) under the name `uImage.bin`. The content of the root file system archive `buildroot/output/images/rootfs.tar.gz` must be extracted in the second SD card partition (ext2).

## Run

To boot U-Boot just flashed into the NAND above, press and hold Power button then while still pressing the Power button, press and hold AUX button for 5 to 8 seconds. To boot U-Boot from the NOR, press and hold the AUX button, while still pressing the AUX button, press and hold the Power button, then release the AUX button.

See complete instructions in [Booting the Neo FreeRunner via U-Boot](http://wiki.openmoko.org/wiki/Booting_the_Neo_FreeRunner_via_U-Boot).

## Configure a custom build

### Packages

The image content can be configured in Buildroot with:

```
$ make -C buildroot/ menuconfig
```

### Boot loader splash screen

To generate an OpenMoko splash screen in the correct format:

```
$ make splash
```

Then add the `splashimage` variable to the NAND U-Boot:

```
setenv splashimage nand read.e 0x32000000 splash 0x5000\; unzip 0x32000000 0x8800000 0x96000 
saveenv 
```

This `splashimage` command loads a maximum compressed splash size of 0x5000 which is 20480 bytes. The file should be smaller than that or the size increase in the U-Boot read command.

See complete instructions in [Configuring the boot splash screens](http://wiki.openmoko.org/wiki/Configuring_the_boot_splash_screens#U-Boot_Splash).

### Network

The IP configuration for the USB gadget ethernet interface resides in `overlay/etc/network/interfaces`. A custom SSID and PSK for the wifi can be added in `overlay/etc/wpa_supplicant.conf`.

## Support

:heavy_check_mark: Build kernel

:heavy_check_mark: Build root file system (JFFS2 in flash)

:heavy_check_mark: Build root file system (SD card)

:heavy_check_mark: Build boot loader

:heavy_check_mark: Boot loader splash screen

:heavy_check_mark: Display (console in frame buffer `/dev/fb0`)

:heavy_check_mark: Display (Xorg with `xdriver_xf86-video-fbdev`, tested with fluxbox)

:heavy_check_mark: Touch screen (`/dev/input/mouse0` output, also working under Xorg)

:heavy_check_mark: Backlight control

:question: USB host

:heavy_check_mark: USB gadget (Ethernet)

:heavy_check_mark: Wifi (WPA2/PSK)

:question: Bluetooth

:heavy_check_mark: GPS (NMEA messages coming on `/dev/s3c2410_serial1`, gpsd working)

:heavy_check_mark: SD card

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

## Unsolved issues

### Wrong kernel configuration

The kernel configuration is overwritten during the buildroot run, which leqds to a built kernel not matching the configuration under `̀configs/kernel`. To rebuild the kernel with the correct configuration, run:

```
$ cp configs/kernel buildroot/output/build/linux-om-gta02-2.6.37/.config
$ make build
```
### First buildroot build fails

The first build fails, other builds succeed:

```
$ make build
which: no dfu-util in (/home/clear/bin:/home/clear/bin:/usr/local/bin:/usr/bin/haswell:/usr/bin:/opt/3rd-party/bin)
make -j`nproc` -C buildroot
make[1]: Entering directory '/share/freerunner/temp/buildroot'
make[1]: *** No rule to make target '/share/freerunner/temp/buildroot/output/.br-external.mk'.  Stop.
make[1]: Leaving directory '/share/freerunner/temp/buildroot'
make: *** [Makefile:20: build] Error 2
$ make build
which: no dfu-util in (/home/clear/bin:/home/clear/bin:/usr/local/bin:/usr/bin/haswell:/usr/bin:/opt/3rd-party/bin)
make -j`nproc` -C buildroot
make[1]: Entering directory '/share/freerunner/temp/buildroot'
/usr/bin/make -j1 O=/share/freerunner/temp/buildroot/output HOSTCC="/usr/bin/gcc" HOSTCXX="/usr/bin/g++" syncconfig
make[2]: Entering directory '/share/freerunner/temp/buildroot'
make[2]: warning: -j1 forced in submake: resetting jobserver mode.
...
```

## Changelog

* next
  * Buildroot 2019.02
  * Linux 2.6.37
  * GCC 4.9.4
  * Added [omhacks](https://github.com/radekp/omhacks)
  * Added network configuration for usb0 and eth0
  * Fixed dependencies for Xorg and fluxbox window manager
  * Added U-Boot build
  * Added SD card image generation
  * Added U-Boot splash screen
* 0.2
  * Buildroot 2020.02
  * Linux 3.2.99
  * GCC 5.5.0
* 0.1
  * Buildroot 2019.02
  * Linux 2.6.37
  * GCC 4.9.4
