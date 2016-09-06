//
//  MyAppHotKeys.m
//
//  Created by chao on 8/12/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "MyAppHotKeys.h"
#import "AppHotKey.h"
#import "../AppUtils/AppUtils.h"
#import "../AppUtils/AppInfo.h"
#import "../AXUIUtils/AXUIApp.h"
#import "../HotKey/HotKey.h"
#import "../HotKey/HotKeyManager.h"
#import "../Utils/Constants.h"

static MyAppHotKeys *_sharedHotKeys = nil;    
static dispatch_once_t  _onceToken;

@interface MyAppHotKeys()

@property (nonatomic, strong) NSMutableArray *appHotKeys;
@property (nonatomic, strong) NSMutableDictionary *installedApps;
@property id observer;
@property SEL observerSelector;

@end

@implementation MyAppHotKeys

+ (instancetype)sharedHotKeys {
    dispatch_once(&_onceToken, ^{
            _sharedHotKeys = [[MyAppHotKeys alloc] init];
        }
        );

    return _sharedHotKeys;
}

- (instancetype)init {
    if (self = [super init]) {
        self.appHotKeys = [[NSMutableArray alloc] init];        
        self.installedApps = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)loadMyAppHotKeys {
    [self.installedApps removeAllObjects]; 
    [AppUtils loadInstalledApps:self.installedApps];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *myHotKeys = [userDefaults dictionaryForKey:MyAppHotKeysKey];

    for (NSString *appID in myHotKeys) {
        NSDictionary *appDict = [myHotKeys objectForKey:appID];
        
        if (appDict) {
            AppInfo *appInfo = [self.installedApps objectForKey:appID];
            if (appInfo == nil) {
                appInfo = [[AppInfo alloc]
                              initWithName:[appDict objectForKey:NameKey]
                                     appID:appID];
            }

            NSString *hotKeyStr = [appDict objectForKey:HotKeyKey];
            AppHotKey *appHotKey = [[AppHotKey alloc]
                                       initWithApp:appInfo
                                         hotKeyStr:hotKeyStr
                                            target:self
                                            action:@selector(launchApp:)];
            [self.appHotKeys addObject:appHotKey];
        }
    }
}

- (void)validateWithInstalledApps {
    [self.installedApps removeAllObjects];
    [AppUtils loadInstalledApps:self.installedApps];

    for (AppHotKey *hotKey in self.appHotKeys) {
        if (![self.installedApps objectForKey:hotKey.appInfo.appID]) {
            NSLog(@"Nonexist application: %@", hotKey.appInfo.appName);
            hotKey.appInfo.isInstalled = NO;
        }
    }
}

- (void)registerAll {
    [self loadMyAppHotKeys];
    HotKeyManager *hotKeyMgr = [HotKeyManager sharedManager];

    for (AppHotKey *appHotKey in self.appHotKeys) {
        if (![hotKeyMgr bind:appHotKey]) {
            NSLog(@"Failed to register hot key for application: %@",
                  appHotKey.appInfo.appName);
        }        
    } 
}

- (void)unregisterAll {
    HotKeyManager *hotKeyMgr = [HotKeyManager sharedManager];
    for (AppHotKey *appHotKey in self.appHotKeys) {
        if (![hotKeyMgr unbind:appHotKey]) {
            NSLog(@"Failed to unregister hot key for application: %@",
                  appHotKey.appInfo.appName);
        }        
    } 
}

- (void)addReloadObserver:(id)observer
                 selector:(SEL)observerSelector {
    self.observer = observer;
    self.observerSelector = observerSelector;
}

- (void)removeReloadObserver {
    self.observer = nil;
    self.observerSelector = nil;
}

- (void)reloadFromPrefs {
    [self registerAll];

    if (self.observer && self.observerSelector) {
        [self.observer perform:self.observerSelector];
    }
}

- (AppHotKey *)appHotKeyAtIndex:(NSInteger)index {
    if (index >= 0 && index < self.appHotKeys.count) {
        return [self.appHotKeys objectAtIndex:index];
    }

    return nil;
}

- (AppHotKey *)addAppHotKey:(AppInfo *)appInfo
                  hotKeyStr:(NSString *)hotKeyStr {
    AppHotKey* appHotKey = [[AppHotKey alloc]
                               initWithApp:appInfo
                                 hotKeyStr:hotKeyStr
                                    target:self
                                    action:@selector(launchApp:)];
    if ([[HotKeyManager sharedManager] bind:appHotKey]) {
        [self.appHotKeys addObject:appHotKey]; 
        return appHotKey;
    }

    NSLog(@"Can not register hot key for application:%@", appInfo.appID);
    return nil;
}

- (BOOL)removeAppHotKeyWithAppID:(NSString *)appID {
    for (AppHotKey *appHotKey in self.appHotKeys) {
        if ([appHotKey.appInfo.appID isEqualToString:appID]) {
            [[HotKeyManager sharedManager] unbind:appHotKey];      
            [self.appHotKeys removeObject:appHotKey];
            return YES;
        } 
    }

    return NO;
}

- (BOOL)removeAppHotKeyAtIndex:(NSInteger)index {
    if (index >= 0 && index < self.appHotKeys.count) {
        AppHotKey *appHotKey = [self.appHotKeys objectAtIndex:index];
        if ([[HotKeyManager sharedManager] unbind:appHotKey]) {
            [self.appHotKeys removeObjectAtIndex:index];
            return YES;
        }
        else {
            NSLog(@"Can't unbind hotkey of application: %@",
                  appHotKey.appInfo.appName);
        }
    }

    return NO;
}

- (NSArray *)getMyAppHotKeys {
    return self.appHotKeys;
}

- (NSDictionary *)getInstalledApps {
    return self.installedApps;
}

- (NSMutableDictionary *)getInstalledAppsWithoutHotKey {
    NSMutableDictionary *apps = [self.installedApps mutableCopy];
    for (AppHotKey *appHotKey in self.appHotKeys) {
        [apps removeObjectForKey:appHotKey.appInfo.appID];
    }

    return apps;
}

- (void)launchApp:(AppHotKey *)hotKey {
    NSArray *applications = [NSWorkspace sharedWorkspace].runningApplications;
    
    for (NSRunningApplication *app in applications) {
        if ([app.bundleIdentifier isEqualToString:hotKey.appInfo.appID]) {
            if (!app.active
                && ![app activateWithOptions:
                     (NSApplicationActivateAllWindows |
                     NSApplicationActivateIgnoringOtherApps)]) {
                    NSLog(@"Can't activate application: %@",
                          hotKey.appInfo.appName);
                }
            
            if (app.hidden && ![app unhide]) {
                NSLog(@"Can't unhide application: %@", hotKey.appInfo.appName);
            }
            
            AXUIApp *axUIApp = [[AXUIApp alloc]
                                initWithPID:app.processIdentifier];
            AXUIWindow *window = [axUIApp getFocusedWindow];
            if (window == nil) {
                window = [axUIApp getMainWindow];
            }
            if (window == nil) {
                NSArray *windows = [axUIApp getAllWindows];
                if (windows && windows.count > 0) {
                    for (AXUIWindow *win in windows) {
                        if ([win isMainWindow]) {
                            window = win;
                            break;
                        }
                    }
                    
                    if (window == nil) {
                        window = [windows objectAtIndex:0];
                    }
                }
            }
            
            if (window != nil) {
                if ([window isMinimized]) {
                    if (![window restoreFromMinimized]) {
                        NSLog(@"Can't restore window from minimized for app: %@"
                              , hotKey.appInfo.appName);
                    }
                }
            }
            else {
                NSLog(@"Can't find activated window for application: %@",
                      hotKey.appInfo.appName);
            }
            
            return;
        }
    }
    
    if (![hotKey.appInfo launch]) {
        NSLog(@"Can't launch application: %@", hotKey.appInfo.appName);
    }
}

@end
