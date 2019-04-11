include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = WiCellSwitcherPrefs
WiCellSwitcherPrefs_FILES = WCSRootListController.m
WiCellSwitcherPrefs_INSTALL_PATH = /Library/PreferenceBundles
WiCellSwitcherPrefs_FRAMEWORKS = UIKit
WiCellSwitcherPrefs_PRIVATE_FRAMEWORKS = Preferences
WiCellSwitcher_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/WiCellSwitcherPrefs.plist$(ECHO_END)
