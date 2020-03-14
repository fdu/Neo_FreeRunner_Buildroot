url_buildroot = https://buildroot.org/downloads/buildroot-2020.02.tar.gz
archive_buildroot = buildroot.tar.gz
dir_download = downloads
dir_configs = configs
dir_buildroot = buildroot
dir_patches_kernel = $(dir_buildroot)/patches/kernel

bootstrap:
	mkdir -p $(dir_download)
	mkdir -p $(dir_buildroot)
	curl $(url_buildroot) > $(dir_download)/$(archive_buildroot)
	curl https://raw.githubusercontent.com/shr-distribution/meta-smartphone/c35ec94cf7ed05d0d030c75325a65aa5f5c55ca7/meta-openmoko/recipes-kernel/linux/linux-openmoko-3.2/om-gta02/shr.patch > $(dir_patches_kernel)/shr.patch
	curl https://raw.githubusercontent.com/shr-distribution/meta-smartphone/c35ec94cf7ed05d0d030c75325a65aa5f5c55ca7/meta-openmoko/recipes-kernel/linux/linux-openmoko-3.2/om-gta02/defconfig > $(dir_configs)/kernel
	tar zxvf $(dir_download)/$(archive_buildroot) -C $(dir_buildroot) --strip-components=1
	cp $(dir_configs)/buildroot $(dir_buildroot)/.config

build:
	$(MAKE) -j$(nproc) -C $(dir_buildroot)

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
