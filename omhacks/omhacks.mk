################################################################################
#
# omhacks
#
################################################################################

OMHACKS_VERSION = a7fc045475ab8de9ff9e1441958115ed930114d7
OMHACKS_SITE_METHOD = git
OMHACKS_SITE = https://github.com/radekp/omhacks
OMHACKS_LICENSE = GPL-2.0+
OMHACKS_INSTALL_STAGING = YES
#LIBUBOX_DEPENDENCIES = $(if $(BR2_PACKAGE_JSON_C),json-c)

$(eval $(cmake-package))
