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

build:
	$(MAKE) -j`nproc` -C $(dir_buildroot)

flash_kernel:
ifeq (, $(shell which dfu-util))
	$(error "No dfu-util in path $(PATH)")
else
	dfu-util -a kernel -R -D $(dir_buildroot)/output/images/uImage
endif

flash_rootfs:
ifeq (, $(shell which dfu-util))
	$(error "No dfu-util in path $(PATH)")
else
	dfu-util -a rootfs -R -D $(dir_buildroot)/output/images/rootfs.jffs2
endif

clean:
	rm -rf $(dir_buildroot) $(dir_download)
