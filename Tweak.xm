//NSMutableDictionary *prefsplistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.brunonfl.wicellswitcherprefs.plist"];
//NSNumber *disconnectOptionDict = [prefsplistDict objectForKey:@"disconnectOptionSwitch"];
#import <Cephei/HBPreferences.h>

/*@interface HBPreferences : NSObject
@end*/

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
- (id)getNetworkPasswordForNetworkNamed:(id)arg1; //get the password for the network
- (int)joinNetworkWithNameAsync:(id)arg1 password:(id)arg2 rememberChoice:(int)arg3; //join said network
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

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)application
{
  %orig();
  if (disconnectOption == NO) wiFiActive = [[%c(SBWiFiManager) sharedInstance] isPowered];
  else {
    if ([[%c(SBWiFiManager) sharedInstance] currentNetworkName] != nil) wiFiActive = YES;
    else wiFiActive = NO;
  }
  cellularActive = [[%c(SBWiFiManager) sharedInstance] isMobileDataEnabled];
  if(wiFiActive == YES && cellularActive == YES){
    justChangedStatus = YES;
    [[%c(SBWiFiManager) sharedInstance] setMobileDataEnabled:NO];
    cellularActivePreviousState = !cellularActive;
    wiFiActivePreviousState = wiFiActive;
  }
}
%end

/*%hook CCUILabeledRoundButton
-(id)initWithHighlightColor:(id)arg1 useLightStyle:(BOOL)arg2{
  wiFiButtonID = arg1;
  %orig();
  return arg1;
}

%new
+(instancetype)alloc{
  static CCUILabeledRoundButton *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
      sharedInstance = [super alloc];
      // Do any other initialisation stuff here
  });
  return sharedInstance;
}

%new
- (void)desligarWiFi{
  [[%c(SBWiFiManager) sharedInstance] setWiFiEnabled:NO];
}
%end*/

%hook SBStatusBarStateAggregator
- (void)_updateDataNetworkItem{
  %orig();
  [[%c(SBWiFiManager) sharedInstance] mobileDataStatusHasChanged];
}
%end

%hook SBWiFiManager
- (void)_powerStateDidChange{
  %orig();
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
- (void)_linkDidChange
{
  %orig();
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

%new
- (void)mobileDataStatusHasChanged{
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
        [[%c(WiFiUtils) sharedInstance] setAutoJoinState: YES];
      }
      cellularActivePreviousState = cellularActive;
      wiFiActivePreviousState = [self isPowered];
    }
  }
  else justChangedStatus = NO;
}

%new
- (BOOL)isMobileDataEnabled{
  return CTCellularDataPlanGetIsEnabled();
}

%new
- (void)setMobileDataEnabled:(BOOL)enabled{
  CTCellularDataPlanSetIsEnabled(enabled);
}

%end

/*%new
- (void)getWiCellSwitcherPrefs{
  prefsplistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.brunonfl.wicellswitcherprefs.plist"];
  disconnectOptionDict = [prefsplistDict objectForKey:@"disconnectOptionSwitch"];

  if (disconnectOptionDict != nil){
    disconnectOption = [[prefsplistDict objectForKey:@"disconnectOptionSwitch"] boolValue];
  }
  else{
    disconnectOption = YES;
  }
  [prefsplistDict release];
}*/

/*static void loadPrefs()
{
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.brunonfl.wicellswitcherprefs.plist"];
  if(prefs)
  {
      disconnectOption = ( [prefs objectForKey:@"disconnectOptionSwitch"] ? [[prefs objectForKey:@"disconnectOptionSwitch"] boolValue] : disconnectOption );
  }
  [prefs release];
}*/

%ctor {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.brunonfl.wicellswitcher"];
    [preferences registerBool:&disconnectOption default:YES forKey:@"disconnectOptionSwitch"];
    //NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.brunonfl.wicellswitcher.plist"];
}

/*%ctor
{
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.brunonfl.wicellswitcherprefs.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  loadPrefs();
}*/
