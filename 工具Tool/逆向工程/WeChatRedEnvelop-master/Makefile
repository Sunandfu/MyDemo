THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 8081
ARCHS = arm64
TARGET = iphone:latest:8.0

include $(THEOS)/makefiles/common.mk

SRC = $(wildcard src/*.m)

TWEAK_NAME = WeChatRedEnvelop
WeChatRedEnvelop_FILES = $(wildcard src/*.m) src/Tweak.xm
WeChatRedEnvelop_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 WeChat"
