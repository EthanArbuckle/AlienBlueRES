include theos/makefiles/common.mk

TWEAK_NAME = AlienBlue
AlienBlue_FILES = Tweak.xm
AlienBlue_FRAMEWORKS = UIKit
export THEOS_DEVICE_IP=192.168.1.11
include $(THEOS_MAKE_PATH)/tweak.mk
