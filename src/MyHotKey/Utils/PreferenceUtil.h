//
//  PreferenceUtil.h
//
//  Created by chao on 8/18/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WindowHotKey;
@class AppHotKey;

@interface PreferenceUtil : NSObject

//+ (BOOL)saveWindowHotKey:(WindowHotKey *)hotKey;
+ (BOOL)saveMyAppHotKeys;
+ (BOOL)saveMyWindowHotKeys;
+ (BOOL)saveSyncPreferences:(BOOL)syncAtStart
                  cloudType:(NSString *)cloudType;
+ (void)registerDefaultHotKeys;
+ (void)cloudSync;

@end
