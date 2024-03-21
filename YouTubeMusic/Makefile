ARCHS = arm64 arm64e

include $(THEOS_MAKE_PATH)/common.mk

TWEAK_NAME = YouTubeMusicMitsuhaForever
PACKAGE_VERSION = 1.0
$(TWEAK_NAME)_FILES = $(shell find . -name '*.xm' -o -name '*.x' -o -name '*.m')
$(TWEAK_NAME)_LIBRARIES += mitsuhaforever bz2 c++ iconv z
$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation AVFoundation AVKit Photos Accelerate CoreMotion GameController VideoToolbox
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -DTWEAK_VERSION=$(PACKAGE_VERSION)

include $(THEOS_MAKE_PATH)/tweak.mk
