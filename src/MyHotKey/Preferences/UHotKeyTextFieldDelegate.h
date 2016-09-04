//
//  UHotKeyTextFieldDelegate.h
//
//  Created by chao on 7/30/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class UHotKeyTextField;

@protocol UHotKeyTextFieldDelegate

- (void)hotKeyDidChange:(UHotKeyTextField *)hotKeyField
                keyCode:(NSUInteger)keyCode
                 keyMod:(NSUInteger)keyMod
                 hotKey:(NSString *)hotKey;

@end
