//
//  AppHotKey.m
//
//  Created by chao on 8/14/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "AppHotKey.h"
#import "HotKey_protected.h"

@interface AppHotKey()

@property (nonatomic, strong, readwrite) AppInfo* appInfo;

@end

@implementation AppHotKey

- (instancetype)initWithApp:(AppInfo *)appInfo
                    keyCode:(NSUInteger)keyCode
                     keyMod:(NSUInteger)keyMod
                     target:(id)target
                     action:(SEL)action {
    if (self = [super initWithKeyCode:keyCode
                               keyMod:keyMod
                               target:target
                               action:action]) {
        self.appInfo = appInfo;
    }

    return self;
}

- (instancetype)initWithApp:(AppInfo *)appInfo
                  hotKeyStr:(NSString *)hotKeyStr
                     target:(id)target
                     action:(SEL)action {
    if (self = [super initWithHotKey:hotKeyStr
                              target:target
                              action:action]) {
        self.appInfo = appInfo;
    }

    return self;
}

@end
