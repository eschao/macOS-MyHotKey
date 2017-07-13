//
//	WindowHotKey.h
//
//	Created by chao on 8/14/16.
//	Copyright © 2016 eschao. All rights reserved.
//

#import "HotKey.h"

@interface WindowHotKey : HotKey

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *desc;
@property (nonatomic, strong, readonly) NSString *defaultHotKey;


- (instancetype)initWithName:(NSString *)name
                 description:(NSString *)description
               defaultHotKey:(NSString *)defaultHotKey
                     keyCode:(NSUInteger)keyCode
                      keyMod:(NSUInteger)keyMod
                      target:(id)target
                      action:(SEL)action;
- (instancetype)initWithName:(NSString *)name
                 description:(NSString *)description
               defaultHotKey:(NSString *)defaultHotKey
                      hotKey:(NSString *)hotKey
                      target:(id)target
                      action:(SEL)action;
- (instancetype)initWithName:(NSString *)name
                 description:(NSString *)description
               defaultHotKey:(NSString *)defaultHotKey
                      target:(id)target
                      action:(SEL)action;
@end
