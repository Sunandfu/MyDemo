THEOS_DEVICE_IP = 192.168.0.105

include $(THEOS)/makefiles/common.mk

SRC = $(wildcard src/*.m)

TWEAK_NAME = DingTalkHelper
DingTalkHelper_FILES = $(wildcard src/*.m) src/Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 DingTalk"
