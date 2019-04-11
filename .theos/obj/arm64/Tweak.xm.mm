#line 1 "Tweak.xm"


#import <Cephei/HBPreferences.h>




@interface SBWiFiManager
+ (id)sharedInstance;
- (BOOL)isPowered;
- (void)_powerStateDidChange;
- (void)_linkDidChange;
- (id)currentNetworkName;
- (BOOL)isAssociated;
- (void)setWiFiEnabled:(BOOL)arg1;

- (void)mobileDataStatusHasChanged;
- (BOOL)isMobileDataEnabled;
- (void)setMobileDataEnabled:(BOOL)enabled;
- (void)getWiCellSwitcherPrefs;
@end

@interface WiFiUtils
+ (id)sharedInstance;
+ (bool)scanInfoIs5GHz:(id)arg1;
- (long)closeWiFi;
- (long)disassociateSync;
- (id)getLinkStatus;
- (id)getNetworkPasswordForNetworkNamed:(id)arg1; 
- (int)joinNetworkWithNameAsync:(id)arg1 password:(id)arg2 rememberChoice:(int)arg3; 
- (BOOL)isJoinInProgress;
- (BOOL)isScanInProgress;
- (BOOL)isScanningActive;
- (void)activateScanning:(BOOL)arg1;
- (void)triggerScan;
- (long)setAutoJoinState:(BOOL)arg1;
- (double)periodicScanInterval;
@end

@interface SBStatusBarStateAggregator
+ (id)sharedInstance;
- (void)_updateDataNetworkItem;
@end

@interface CCUILabeledRoundButton
@property (nonatomic, copy, readwrite) NSString *title;
-(id)initWithHighlightColor:(id)arg1 useLightStyle:(BOOL)arg2;

+ (id)sharedTeste;
- (void)desligarWiFi;
@end

HBPreferences *preferences;

BOOL cellularActive;
BOOL wiFiActive;
BOOL cellularActivePreviousState;
BOOL wiFiActivePreviousState;
BOOL justChangedStatus;
BOOL disconnectOption = true;
id   wiFiButtonID;

extern "C" Boolean CTCellularDataPlanGetIsEnabled();
extern "C" void CTCellularDataPlanSetIsEnabled(Boolean enabled);


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

@class SBWiFiManager; @class SpringBoard; @class WiFiUtils; @class SBStatusBarStateAggregator; 
static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$SBStatusBarStateAggregator$_updateDataNetworkItem)(_LOGOS_SELF_TYPE_NORMAL SBStatusBarStateAggregator* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBStatusBarStateAggregator$_updateDataNetworkItem(_LOGOS_SELF_TYPE_NORMAL SBStatusBarStateAggregator* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SBWiFiManager$_powerStateDidChange)(_LOGOS_SELF_TYPE_NORMAL SBWiFiManager* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBWiFiManager$_powerStateDidChange(_LOGOS_SELF_TYPE_NORMAL SBWiFiManager* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SBWiFiManager$_linkDidChange)(_LOGOS_SELF_TYPE_NORMAL SBWiFiManager* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBWiFiManager$_linkDidChange(_LOGOS_SELF_TYPE_NORMAL SBWiFiManager* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBWiFiManager$mobileDataStatusHasChanged(_LOGOS_SELF_TYPE_NORMAL SBWiFiManager* _LOGOS_SELF_CONST, SEL); static BOOL _logos_method$_ungrouped$SBWiFiManager$isMobileDataEnabled(_LOGOS_SELF_TYPE_NORMAL SBWiFiManager* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBWiFiManager$setMobileDataEnabled$(_LOGOS_SELF_TYPE_NORMAL SBWiFiManager* _LOGOS_SELF_CONST, SEL, BOOL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$WiFiUtils(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("WiFiUtils"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBWiFiManager(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBWiFiManager"); } return _klass; }
#line 66 "Tweak.xm"


static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id application) {
  _logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, application);
  if (disconnectOption == NO) wiFiActive = [[_logos_static_class_lookup$SBWiFiManager() sharedInstance] isPowered];
  else {
    if ([[_logos_static_class_lookup$SBWiFiManager() sharedInstance] currentNetworkName] != nil) wiFiActive = YES;
    else wiFiActive = NO;
  }
  cellularActive = [[_logos_static_class_lookup$SBWiFiManager() sharedInstance] isMobileDataEnabled];
  if(wiFiActive == YES && cellularActive == YES){
    justChangedStatus = YES;
    [[_logos_static_class_lookup$SBWiFiManager() sharedInstance] setMobileDataEnabled:NO];
    cellularActivePreviousState = !cellularActive;
    wiFiActivePreviousState = wiFiActive;
  }
}



























static void _logos_method$_ungrouped$SBStatusBarStateAggregator$_updateDataNetworkItem(_LOGOS_SELF_TYPE_NORMAL SBStatusBarStateAggregator* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
  _logos_orig$_ungrouped$SBStatusBarStateAggregator$_updateDataNetworkItem(self, _cmd);
  [[_logos_static_class_lookup$SBWiFiManager() sharedInstance] mobileDataStatusHasChanged];
}



static void _logos_method$_ungrouped$SBWiFiManager$_powerStateDidChange(_LOGOS_SELF_TYPE_NORMAL SBWiFiManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
  _logos_orig$_ungrouped$SBWiFiManager$_powerStateDidChange(self, _cmd);
  if (justChangedStatus == NO && disconnectOption == NO){
    cellularActive = [self isMobileDataEnabled];
    if ([self currentNetworkName] != nil) wiFiActive = YES;
    else wiFiActive = NO;
    if(wiFiActive != wiFiActivePreviousState){
      justChangedStatus = YES;
      if (wiFiActive == YES){
        [self setMobileDataEnabled:NO];
      }
      else{
        [self setMobileDataEnabled:YES];
      }
      cellularActivePreviousState = [self isMobileDataEnabled];
      wiFiActivePreviousState = wiFiActive;
    }
  }
  else justChangedStatus = NO;
}

static void _logos_method$_ungrouped$SBWiFiManager$_linkDidChange(_LOGOS_SELF_TYPE_NORMAL SBWiFiManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
  _logos_orig$_ungrouped$SBWiFiManager$_linkDidChange(self, _cmd);
  if (justChangedStatus == NO && disconnectOption == YES){
    cellularActive = [self isMobileDataEnabled];
    wiFiActive = [self isAssociated];
    if(wiFiActive != wiFiActivePreviousState){
      justChangedStatus = YES;
      if (wiFiActive == YES){
        [self setMobileDataEnabled:NO];
      }
      else{
        [self setMobileDataEnabled:YES];
      }
      cellularActivePreviousState = [self isMobileDataEnabled];
      wiFiActivePreviousState = wiFiActive;
    }
  }
  else justChangedStatus = NO;
}


static void _logos_method$_ungrouped$SBWiFiManager$mobileDataStatusHasChanged(_LOGOS_SELF_TYPE_NORMAL SBWiFiManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
  if (justChangedStatus == NO && disconnectOption == NO){
    cellularActive = [self isMobileDataEnabled];
    wiFiActive = [self isPowered];
    if(cellularActive != cellularActivePreviousState){
      justChangedStatus = YES;
      if (cellularActive == YES){
        [self setWiFiEnabled:NO];
      }
      else{
        [self setWiFiEnabled:YES];
        [[_logos_static_class_lookup$WiFiUtils() sharedInstance] setAutoJoinState: YES];
      }
      cellularActivePreviousState = cellularActive;
      wiFiActivePreviousState = [self isPowered];
    }
  }
  else justChangedStatus = NO;
}


static BOOL _logos_method$_ungrouped$SBWiFiManager$isMobileDataEnabled(_LOGOS_SELF_TYPE_NORMAL SBWiFiManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
  return CTCellularDataPlanGetIsEnabled();
}


static void _logos_method$_ungrouped$SBWiFiManager$setMobileDataEnabled$(_LOGOS_SELF_TYPE_NORMAL SBWiFiManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL enabled){
  CTCellularDataPlanSetIsEnabled(enabled);
}



























static __attribute__((constructor)) void _logosLocalCtor_a4679f28(int __unused argc, char __unused **argv, char __unused **envp) {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.brunonfl.wicellswitcher"];
    [preferences registerBool:&disconnectOption default:YES forKey:@"disconnectOptionSwitch"];
    
}






static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);Class _logos_class$_ungrouped$SBStatusBarStateAggregator = objc_getClass("SBStatusBarStateAggregator"); MSHookMessageEx(_logos_class$_ungrouped$SBStatusBarStateAggregator, @selector(_updateDataNetworkItem), (IMP)&_logos_method$_ungrouped$SBStatusBarStateAggregator$_updateDataNetworkItem, (IMP*)&_logos_orig$_ungrouped$SBStatusBarStateAggregator$_updateDataNetworkItem);Class _logos_class$_ungrouped$SBWiFiManager = objc_getClass("SBWiFiManager"); MSHookMessageEx(_logos_class$_ungrouped$SBWiFiManager, @selector(_powerStateDidChange), (IMP)&_logos_method$_ungrouped$SBWiFiManager$_powerStateDidChange, (IMP*)&_logos_orig$_ungrouped$SBWiFiManager$_powerStateDidChange);MSHookMessageEx(_logos_class$_ungrouped$SBWiFiManager, @selector(_linkDidChange), (IMP)&_logos_method$_ungrouped$SBWiFiManager$_linkDidChange, (IMP*)&_logos_orig$_ungrouped$SBWiFiManager$_linkDidChange);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBWiFiManager, @selector(mobileDataStatusHasChanged), (IMP)&_logos_method$_ungrouped$SBWiFiManager$mobileDataStatusHasChanged, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBWiFiManager, @selector(isMobileDataEnabled), (IMP)&_logos_method$_ungrouped$SBWiFiManager$isMobileDataEnabled, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBWiFiManager, @selector(setMobileDataEnabled:), (IMP)&_logos_method$_ungrouped$SBWiFiManager$setMobileDataEnabled$, _typeEncoding); }} }
#line 226 "Tweak.xm"
