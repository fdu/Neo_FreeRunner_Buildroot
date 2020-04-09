################################################################################
#
# wmiconfig
#
################################################################################

WMICONFIG_VERSION = 0bde889e6fc09a330d0e0b9eb9808b20b2bf13d1
WMICONFIG_SITE_METHOD = git
WMICONFIG_SITE = https://github.com/openmoko/openmoko-svn.git
WMICONFIG_LICENSE = GPL-2.0+
WMICONFIG_INSTALL_STAGING = YES
WMICONFIG_SUBDIR = src/target/AR6kSDK.build_sw.18/host/tools/wmiconfig

define WMICONFIG_BUILD_CMDS
  $(TARGET_CC) $(@D)/$(WMICONFIG_SUBDIR)/wmiconfig.c \
    -DUSER_KEYS \
    -I$(@D)/$(WMICONFIG_SUBDIR)/../../include \
    -I$(@D)/$(WMICONFIG_SUBDIR)/../../../include \
    -I$(@D)/$(WMICONFIG_SUBDIR)/../../wlan/include \
    -I$(@D)/$(WMICONFIG_SUBDIR)/../../os/linux/include \
    -o $(@D)/wmiconfig
endef

define WMICONFIG_INSTALL_STAGING_CMDS
  $(INSTALL) -D -m 0755 $(@D)/wmiconfig $(STAGING_DIR)/usr/bin/wmiconfig
endef

define WMICONFIG_INSTALL_TARGET_CMDS
  $(INSTALL) -D -m 0755 $(@D)/wmiconfig $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
