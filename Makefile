url_buildroot = https://buildroot.org/downloads/buildroot-2019.02.tar.gz
archive_buildroot = buildroot.tar.gz
dir_download = downloads
dir_configs = configs
dir_buildroot = buildroot
dir_patches = patches

bootstrap:
	mkdir -p $(dir_download)
	mkdir -p $(dir_buildroot)
	curl $(url_buildroot) > $(dir_download)/$(archive_buildroot)
	tar zxf $(dir_download)/$(archive_buildroot) -C $(dir_buildroot) --strip-components=1
	cp $(dir_configs)/buildroot $(dir_buildroot)/.config
	ln -s `pwd`/omhacks $(dir_buildroot)/package/omhacks
	patch -p0 < $(dir_patches)/buildroot/0001-add-omhacks.patch
	patch -p0 < $(dir_patches)/buildroot/0002-fbdev-5.0.patch
	patch -p0 < $(dir_patches)/buildroot/0003-uboot-udfu.patch

build:
	$(MAKE) -j`nproc` -C $(dir_buildroot)

flash:
ifeq (, $(shell which dfu-util))
	$(error "No dfu-util in path $(PATH)")
else
	dfu-util -a u-boot -R -D $(dir_buildroot)/output/images/u-boot.udfu
	sleep 2
	dfu-util -a kernel -R -D $(dir_buildroot)/output/images/uImage
	sleep 2
	dfu-util -a rootfs -R -D $(dir_buildroot)/output/images/rootfs.jffs2
endif

clean:
	rm -rf $(dir_buildroot) $(dir_download)
