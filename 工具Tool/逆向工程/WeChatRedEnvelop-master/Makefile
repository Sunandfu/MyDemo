THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 8081
ARCHS = arm64
TARGET = iphone:latest:8.0

include $(THEOS)/makefiles/common.mk

SRC = $(wildcard src/*.m)

TWEAK_NAME = WeChatRedEnvelopesHelper
WeChatRedEnvelopesHelper_FILES = $(wildcard src/*.m) $(wildcard src/*.xm)
WeChatRedEnvelopesHelper_FRAMEWORKS = UIKit
                     
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 WeChat"


