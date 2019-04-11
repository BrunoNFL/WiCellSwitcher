#line 1 "Tweak.xm"
#import <UIKit/UIKit.h>

#import <AudioToolbox/AudioServices.h>




#define DegreesToRadians(degrees) (degrees * M_PI / 180)

@interface WiFiUtils
+ (id)sharedInstance;
+ (bool)scanInfoIs5GHz:(id)arg1;
- (long)closeWiFi;
- (long)disassociateSync;
- (id)getLinkStatus;
- (BOOL)isJoinInProgress;
- (BOOL)isScanInProgress;
- (BOOL)isScanningActive;
- (void)activateScanning:(BOOL)arg1;
- (void)triggerScan;
- (long)setAutoJoinState:(BOOL)arg1;
- (double)periodicScanInterval;
@end

@interface SBWiFiManager
+ (id)sharedInstance;
- (void)_linkDidChange;
- (id)currentNetworkName;
- (void)prefsCallWiJoinTestNotification;
- (BOOL)isAssociated;
@end

@interface CTDataStatus
+(BOOL)supportsSecureCoding;
-(void)setCellularDataPossible:(BOOL)arg1 ;
@end







#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class CTDataStatus; @class SBWiFiManager; @class SpringBoard; 
static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$SBWiFiManager$_linkDidChange)(_LOGOS_SELF_TYPE_NORMAL SBWiFiManager* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBWiFiManager$_linkDidChange(_LOGOS_SELF_TYPE_NORMAL SBWiFiManager* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$CTDataStatus(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("CTDataStatus"); } return _klass; }
#line 43 "Tweak.xm"


static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id application) {
  _logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, application);
  


}




static void _logos_method$_ungrouped$SBWiFiManager$_linkDidChange(_LOGOS_SELF_TYPE_NORMAL SBWiFiManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$SBWiFiManager$_linkDidChange(self, _cmd);
    if([[_logos_static_class_lookup$CTDataStatus() supportsSecureCoding] cellularDataPossible]){
      [[_logos_static_class_lookup$CTDataStatus() supportsSecureCoding] setCellularDataPossible:NO];
    }
    else{
      [[_logos_static_class_lookup$CTDataStatus() supportsSecureCoding] setCellularDataPossible:YES];
    }
    









}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);Class _logos_class$_ungrouped$SBWiFiManager = objc_getClass("SBWiFiManager"); MSHookMessageEx(_logos_class$_ungrouped$SBWiFiManager, @selector(_linkDidChange), (IMP)&_logos_method$_ungrouped$SBWiFiManager$_linkDidChange, (IMP*)&_logos_orig$_ungrouped$SBWiFiManager$_linkDidChange);} }
#line 75 "Tweak.xm"
