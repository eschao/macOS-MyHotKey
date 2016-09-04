//
//  HotKey.m
//
//  Created by chao on 7/12/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "HotKey_protected.h"
#import "HotKeyMap.h"

@interface HotKey()
{
    EventHotKeyRef keyRef;
}

@property (readwrite) NSUInteger keyCode;
@property (readwrite) NSUInteger keyMod;
@property (readwrite) BOOL  enabled;
@property id    target;
@property SEL   action;

@end

@implementation HotKey

- (instancetype)initWithKeyCode:(NSUInteger)keyCode
                      keyMod:(NSUInteger)keyMod
                      target:(id)target
                      action:(SEL)action {
    if (self = [super init]) {
        self.keyMod = keyMod;
        self.keyCode = keyCode;
        self.target = target;
        self.action = action;
        self.enabled = YES;
        self->keyRef = NULL;
    }

    return self;
}

- (instancetype)initWithHotKey:(NSString *)hotKey
                      target:(id)target
                      action:(SEL)action {
    if (self = [super init]) {
        self.target = target;
        self.action = action;
        self->keyRef = NULL;

        CombinedKey combinedKey = {0, 0};
        if ([self parseHotKey:hotKey combinedKey:&combinedKey]) {
            self.keyCode = combinedKey.keyCode;
            self.keyMod = combinedKey.keyMod;
        }
    }

    return self;
}

- (NSString *)getName {
    return @"";
}

- (NSNumber *)getID {
    uint64_t x = self.keyCode;
    x = (x << 32) + self.keyMod;
    return [NSNumber numberWithUnsignedLongLong:x];
}

+ (NSNumber *)getID:(NSUInteger)keyCode
             keyMod:(NSUInteger)keyMod {
    uint64_t x = keyCode;
    x = (x << 32) + keyMod;
    return [NSNumber numberWithUnsignedLongLong:x];
}

- (BOOL)register {
    if (self.enabled) {
        return NO;
    }

    EventHotKeyID hotKeyID;
    hotKeyID.id = (UInt32)self.keyMod;
    hotKeyID.signature = (UInt32)self.keyCode;

    OSStatus status = RegisterEventHotKey((UInt32)self.keyCode,
                                          (UInt32)self.keyMod,
                                          hotKeyID,
                                          GetApplicationEventTarget(), 0,
                                          &(self->keyRef));
    if (status != 0) {
        NSLog(@"Failed to register hot key(name:%@, key:%ld, mod:%ld)\
                status: %d", [self getName], self.keyCode, self.keyMod,
              status);
        return NO;
    }

    return YES;
}

- (BOOL)registerWith:(NSString *)hotKey {
    if (self.enabled) {
        return NO;
    }

    if (hotKey == nil) {
        NSLog(@"Hot key is null!");
        return NO;
    }

    CombinedKey cKey = {0, 0};
    if (![self parseHotKey:hotKey combinedKey:&cKey]) {
        return NO; 
    }

    if (cKey.keyCode != self.keyCode ||
        cKey.keyMod != self.keyMod) {
        if (![self unregister]) {
            return NO;
        }

        self.keyCode = cKey.keyCode; 
        self.keyMod = cKey.keyMod;
        return [self register];
    }

    NSLog(@"Warning: no need to register since the same key code and\
            key mod!");
    return YES;
}

- (BOOL)registerWith:(NSUInteger)keyCode
              keyMod:(NSUInteger)keyMod {
    if (self.enabled) {
        return NO;
    }

    if (keyCode != self.keyCode ||
        keyMod != self.keyMod) {
        if (![self unregister]) {
            return NO;
        }

        self.keyCode = keyCode;
        self.keyMod = keyMod;
        return [self register];
    }

    return YES;
}

- (BOOL)unregister {
    if (self->keyRef) {
        OSStatus status = UnregisterEventHotKey(self->keyRef);
        if (status) {
            NSLog(@"Can't unregister hot key: %@", [self getName]);
            return NO;
        }

        self->keyRef = NULL;
    }

    return YES;
}

- (BOOL)enable:(NSString *)hotKey {
    if (hotKey == nil) {
        return NO;
    }

    CombinedKey cKey = {0, 0};
    if (![self parseHotKey:hotKey combinedKey:&cKey]) {
        return NO; 
    }
     
    self.enabled = YES;
    if (self.keyCode != cKey.keyCode ||
        self.keyMod != cKey.keyMod) {
        if (![self unregister]) {
            NSLog(@"Can't enable since failed to unregister");
            return NO;
        }

        self.keyCode = cKey.keyCode;
        self.keyMod = cKey.keyMod;
        return [self register];
    }

    return YES;
}

- (BOOL)disable {
    if (![self unregister]) {
        NSLog(@"Can't disable since failed to unregister");
        return NO;
    } 

    self.enabled = NO;
    return YES;
}

- (BOOL)canRestoreWithDefaultHotKey {
    return NO;
}

- (void)perform {
    #pragma clang diagnostic push
    #pragma clang diagnostic ingored "-Warc-performSelector-leaks"
        [self.target performSelector:self.action withObject:self];
    #pragma clang diagnostic pop
}

- (BOOL)parseHotKey:(NSString *)hotKey
        combinedKey:(CombinedKey *)combinedKey {
    NSArray *keys = [[hotKey lowercaseString]
                            componentsSeparatedByString:@" "];
    HotKeyMap *maps = [HotKeyMap sharedMap];

    if (keys.count == 1) {
        for (int i=0; i<hotKey.length; ++i) {
            unichar c = [hotKey characterAtIndex:i];
            NSString *key = [NSString stringWithCharacters:&c length:1];
            NSNumber *code = [maps.mod2Code objectForKey:key];
            if (code != nil) {
                combinedKey->keyMod += [code unsignedLongValue];
            }
            else {
                code = [maps.key2Code objectForKey:[key lowercaseString]];
                if (code != nil) {
                    combinedKey->keyCode = [code unsignedLongValue];
                }
                else {
                    NSLog(@"Can not reconganize key: %@", key);
                    return NO;
                }
            }
        } 
    }
    else {
        for (NSString *key in keys) {
            NSNumber *code = [maps.mod2Code objectForKey:key];

            if (code != nil) {
                combinedKey->keyMod += [code unsignedLongValue]; 
            }
            else {
                code = [maps.key2Code objectForKey:[key lowercaseString]];
                if (code != nil) {
                    combinedKey->keyCode = [code unsignedLongValue];
                }
                else {
                    NSLog(@"Can not reconganize key: %@", key);
                    return NO;
                }
            }
        }
    }

    return YES;
}

- (NSString *)hotKey2String {
    return [HotKey hotKey2String:self.keyCode
                          keyMod:self.keyMod];
}

+ (NSString *)hotKey2String:(NSUInteger)keyCode
                     keyMod:(NSUInteger)keyMod {
    NSMutableString * desc = [[NSMutableString alloc] init];

    if ((keyMod & cmdKey) > 0) {
        [desc appendString:@"⌘"]; 
    }

    if ((keyMod & shiftKey) > 0) {
        [desc appendString:@"⇧"];
    }

    if ((keyMod & optionKey) > 0) {
        [desc appendString:@"⌥"];
    }

    if ((keyMod & controlKey) > 0) {
        [desc appendString:@"⌃"];
    }

    NSString *key = [[HotKeyMap sharedMap].code2Key
                        objectForKey:@(keyCode)];
    if (key != nil) {
        [desc appendString:key];    
    }
    else {
        NSLog(@"Can not map key for int: %ld", keyCode);
    }
    return desc;
}

@end
