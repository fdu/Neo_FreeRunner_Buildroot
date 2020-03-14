Linux system build for the Neo FreeRunner with Buildroot
========================================================

This project is a set of patches and configuration files for [Buildroot](https://buildroot.org/) to build a Linux system image with a minimal root file system for the great [Openmoko Neo FreeRunner (GTA02)](http://wiki.openmoko.org/wiki/Neo_FreeRunner).

Build
-----

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

Flash the device
----------------

The images can be flashed with dfu-util by following with standard [Neo FreeRunner flashing instructions](http://wiki.openmoko.org/wiki/Flashing_the_Neo_FreeRunner) or by using:

```
$ make flash_kernel
$ make flash_rootfs
```

Changelog
---------

* 0.1
  * Buildroot 2019.02
  * Linux 2.6.37
  * GCC 4.9.4
