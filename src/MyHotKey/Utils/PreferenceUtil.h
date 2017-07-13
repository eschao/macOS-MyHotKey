//
//	PreferenceUtil.h
//
//	Created by chao on 8/18/16.
//	Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WindowHotKey;
@class AppHotKey;

@interface PreferenceUtil : NSObject

+ (BOOL)saveMyAppHotKeys;
+ (BOOL)saveMyWindowHotKeys;
+ (BOOL)saveSyncPreferences:(BOOL)autoSync
                  cloudType:(NSString *)cloudType;
+ (void)registerDefault;

@end
