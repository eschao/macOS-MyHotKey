//
//  AppHotKey.h
//
//  Created by chao on 8/14/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "HotKey.h"

@class AppInfo;

@interface AppHotKey : HotKey

@property (nonatomic, strong, readonly) AppInfo* appInfo;

- (instancetype)initWithApp:(AppInfo *)appInfo
                    keyCode:(NSUInteger)keyCode
                     keyMod:(NSUInteger)keyMod
                     target:(id)target
                     action:(SEL)action; 
- (instancetype)initWithApp:(AppInfo *)appInfo
                  hotKeyStr:(NSString *)hotKeyStr
                     target:(id)target
                     action:(SEL)action;

@end
