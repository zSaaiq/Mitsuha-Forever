FINALPACKAGE = 1

PREFIX = $(THEOS)/toolchain/XcodeDefault.xctoolchain/usr/bin/
THEOS_PACKAGE_SCHEME=rootless
export ADDITIONAL_CFLAGS = -DTHEOS_LEAN_AND_MEAN -fobjc-arc -O3
export TARGET = iphone:15.6


include $(THEOS)/makefiles/common.mk

SUBPROJECTS += ASSWatchdog Music Prefs Spotify Springboard

after-install::
	install.exec "killall -9 SpringBoard"

include $(THEOS_MAKE_PATH)/aggregate.mk
