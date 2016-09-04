//
//  HotKey.h
//
//  Created by chao on 7/12/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface HotKey : NSObject

@property (readonly) NSUInteger keyCode;
@property (readonly) NSUInteger keyMod;
@property (readonly) BOOL enabled;

- (instancetype)initWithKeyCode:(NSUInteger)keyCode
                         keyMod:(NSUInteger)keyMod
                         target:(id)target
                         action:(SEL)action;
- (instancetype)initWithHotKey:(NSString *)hotKey
                        target:(id)target
                        action:(SEL)action;

- (NSNumber *)getID;
- (BOOL)register;
- (BOOL)registerWith:(NSString *)hotKey;
- (BOOL)registerWith:(NSUInteger)keyCode
              keyMod:(NSUInteger)keyMod;
- (BOOL)unregister;
- (BOOL)canRestoreWithDefaultHotKey;
- (BOOL)enable:(NSString *)hotKey; 
- (BOOL)disable; 

- (void)perform;
- (NSString *)hotKey2String;

+ (NSNumber *)getID:(NSUInteger)keyCode
             keyMod:(NSUInteger)keyMod;
+ (NSString *)hotKey2String:(NSUInteger)keyCode
                     keyMod:(NSUInteger)keyMod;

@end
