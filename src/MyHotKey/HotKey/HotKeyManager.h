//
//  HotKeyManager.h
//
//  Created by chao on 7/11/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@class HotKey;

@interface HotKeyManager : NSObject

+ (instancetype)sharedManager;

- (void)dispatch:(NSNumber *)hotKeyID;

/*
- (HotKey *)bind:(NSString *)name
          hotKey:(NSString *)hotKey
   defaultHotKey:(NSString *)defaultHotKey
          target:(id)targewt
          action:(SEL)action;
- (HotKey *)bind:(NSString *)name
   defaultHotKey:(NSString *)defaultHotKey
         keyCode:(NSUInteger)keyCode
          keyMod:(NSUInteger)keyMod
          target:(id)target
          action:(SEL)action;
*/
- (BOOL)bind:(HotKey *)hotKey;
- (BOOL)bind:(HotKey *)hotKey
   newHotKey:(NSString *)newHotKey;
- (BOOL)bind:(HotKey *)hotKey
  newKeyCode:(NSInteger)newKeyCode
   newKeyMod:(NSInteger)newKeyMod;
- (BOOL)unbind:(HotKey *)hotKey;
- (HotKey *)isRegistered:(NSUInteger)keyCode
                  keyMod:(NSUInteger)keyMod;
- (BOOL)isSystemHotKey:(NSUInteger)keyCode
                keyMod:(NSUInteger)keyMod;
- (NSArray *)getAllHotKeys;

@end
