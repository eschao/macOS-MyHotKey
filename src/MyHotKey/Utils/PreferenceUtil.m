//
//  PreferenceUtil.m
//
//  Created by chao on 8/18/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "PreferenceUtil.h"
#import "../AppUtils/AppInfo.h"
#import "../HotKey/AppHotKey.h"
#import "../HotKey/WindowHotKey.h"
#import "../HotKey/MyAppHotKeys.h"
#import "../HotKey/HotKeyManager.h"
#import "CloudSync.h"
#import "GoogleDriveSync.h"
#import "iCloudSync.h"
#import "Constants.h"

@implementation PreferenceUtil

+ (BOOL)saveMyWindowHotKeys {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *prefHotKeys = [[NSMutableDictionary alloc] init];
    NSArray *allHotKeys = [[HotKeyManager sharedManager] getAllHotKeys];
    Class type = [WindowHotKey class];

    [userDefaults setDouble:[[NSDate date] timeIntervalSince1970]
                     forKey:UpdateDateKey];

    for (HotKey *hotKey in allHotKeys) {
        if ([hotKey isKindOfClass:type]) {
            WindowHotKey *winHotKey = (WindowHotKey *)hotKey;
            NSDictionary *value = @{
                HotKeyKey : [winHotKey hotKey2String],
                EnabledKey : [NSNumber numberWithBool:winHotKey.enabled]
            };
            
            [prefHotKeys setObject:value forKey:winHotKey.name];
        }
    }

    [userDefaults setObject:prefHotKeys forKey:MyWindowHotKeysKey];
    return YES;
}

+ (BOOL)saveMyAppHotKeys {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *prefHotKeys = [[NSMutableDictionary alloc] init];
    NSArray *myHotKeys = [[MyAppHotKeys sharedHotKeys] getMyAppHotKeys];

    [userDefaults setDouble:[[NSDate date] timeIntervalSince1970]
                     forKey:UpdateDateKey];
     
    for (AppHotKey *appHotKey in myHotKeys) {
        NSDictionary *value = @{
                        NameKey : appHotKey.appInfo.appName,
                        HotKeyKey : [appHotKey hotKey2String]
        };
        
        [prefHotKeys setObject:value forKey:appHotKey.appInfo.appID];
    }
    
    [userDefaults setObject:prefHotKeys forKey:MyAppHotKeysKey];
    return YES;
}

+ (BOOL)saveSyncPreferences:(BOOL)syncAtStart
                  cloudType:(NSString *)cloudType {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setDouble:[[NSDate date] timeIntervalSince1970]
                     forKey:UpdateDateKey];
    [userDefaults setBool:syncAtStart forKey:SyncAtStartKey];

    if (cloudType != nil) {
        [userDefaults setObject:cloudType forKey:SyncAccountTypeKey];
    }
    return YES;
}

+ (void)registerDefaultHotKeys {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *hotKeys = @{v2GridsLeftName : @{
                                    HotKeyKey : v2GridsLeftHKey,
                                    EnabledKey : @"YES"},
                                
                                v2GridsRightName : @{
                                    HotKeyKey : v2GridsRightHKey,
                                    EnabledKey : @"YES"},
                                
                                h2GridsTopName : @{
                                    HotKeyKey : h2GridsTopHKey,
                                    EnabledKey : @"YES"},
                                
                                h2GridsBottomName : @{
                                    HotKeyKey : h2GridsBottomHKey,
                                    EnabledKey : @"YES"},
                            
                                v3GridsLeftName : @{
                                    HotKeyKey : v3GridsLeftHKey,
                                    EnabledKey : @"YES"},
                                
                                v3GridsMiddleName : @{
                                    HotKeyKey : v3GridsMiddleHKey,
                                    EnabledKey : @"YES"},
                                
                                v3GridsRightName : @{
                                    HotKeyKey : v3GridsRightHKey,
                                    EnabledKey : @"YES"},
                                
                                v3GridsLeftMiddleName : @{
                                    HotKeyKey : v3GridsLeftMiddleHKey,
                                    EnabledKey : @"YES"},
                                
                                v3GridsMiddleRightName : @{
                                    HotKeyKey : v3GridsMiddleRightHKey,
                                    EnabledKey : @"YES"},
                                
                                h3GridsTopName : @{
                                    HotKeyKey : h3GridsTopHKey,
                                    EnabledKey : @"YES"},
                                
                                h3GridsCenterName : @{
                                    HotKeyKey : h3GridsCenterHKey,
                                    EnabledKey : @"YES"},
                                
                                h3GridsBottomName : @{
                                    HotKeyKey : h3GridsBottomHKey,
                                    EnabledKey : @"YES"},
                                
                                h3GridsTopCenterName : @{
                                    HotKeyKey : h3GridsTopCenterHKey,
                                    EnabledKey : @"YES"},
                                
                                h3GridsCenterBottomName : @{
                                    HotKeyKey : h3GridsCenterBottomHKey,
                                    EnabledKey : @"YES"},
                                
                                e4Grids_1_Name : @{
                                    HotKeyKey : e4Grids_1_HKey,
                                    EnabledKey : @"YES"},
                                
                                e4Grids_2_Name : @{
                                    HotKeyKey : e4Grids_2_HKey,
                                    EnabledKey : @"YES"},
                                
                                e4Grids_3_Name : @{
                                    HotKeyKey : e4Grids_3_HKey,
                                    EnabledKey : @"YES"},
                                
                                e4Grids_4_Name : @{
                                    HotKeyKey : e4Grids_4_HKey,
                                    EnabledKey : @"YES"},
                                
                                minimizeWinName : @{
                                    HotKeyKey : minimizeWinHKey,
                                    EnabledKey : @"YES"},
                                
                                maximizeWinName : @{
                                    HotKeyKey : maximizeWinHKey,
                                    EnabledKey : @"YES"},
                                
                                fullscreenWinName : @{
                                    HotKeyKey : fullscreenWinHKey,
                                    EnabledKey : @"YES"},
                                
                                centerWinName : @{
                                    HotKeyKey : centerWinHKey,
                                    EnabledKey : @"YES"
                                } };
    NSString *date = [NSString stringWithFormat:@"%f",
                      [[NSDate date] timeIntervalSince1970]];
    NSDictionary *defaults = @{
                    UpdateDateKey : date,
                    MyWindowHotKeysKey : hotKeys};
    [userDefaults registerDefaults:defaults];
}

+ (void)cloudSync {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id<CloudSync> syncDelegate = nil;
    NSString *accountType = [userDefaults objectForKey:SyncAccountTypeKey];
    if (accountType == nil) {
        
    }
    else if ([accountType isEqualToString:@"iCloud"]) {
        syncDelegate = [[iCloudSync alloc] initWithDelegate:nil];
    }
    else if ([accountType isEqualToString:@"Google Drive"]) {
        syncDelegate = [[GoogleDriveSync alloc] initWithWindow:nil
                                                      delegate:self];
    }

    if (syncDelegate != nil && [syncDelegate isSignedIn]) {
        [syncDelegate sync];
    }
}

@end
