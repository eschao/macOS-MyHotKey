//
//  MyAppHotKeys.h
//
//  Created by chao on 8/12/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AppInfo;
@class AppHotKey;

@interface MyAppHotKeys : NSObject

+ (instancetype)sharedHotKeys;

- (void)loadMyAppHotKeys;
- (void)validateWithInstalledApps;
- (void)registerAll;
- (void)unregisterAll;
- (AppHotKey *)appHotKeyAtIndex:(NSInteger)index; 
- (AppHotKey *)addAppHotKey:(AppInfo *)appInfo
                  hotKeyStr:(NSString *)hotKeyStr;
- (BOOL)removeAppHotKeyWithAppID:(NSString *)appID;
- (BOOL)removeAppHotKeyAtIndex:(NSInteger)index;
- (NSArray *)getMyAppHotKeys;
- (NSDictionary *)getInstalledApps;
- (NSMutableDictionary *)getInstalledAppsWithoutHotKey;

@end
