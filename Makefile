include $(THEOS)/makefiles/common.mk

export ARCHS = arm64

export TARGET = iphone::12.1:12.1

FINALPACKAGE=1

TWEAK_NAME = WiCellSwitcher
WiCellSwitcher_FILES = Tweak.xm
WiCellSwitcher_FRAMEWORKS = UIKit CoreTelephony SystemConfiguration Foundation
WiCellSwitcher_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += wicellswitcherprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
