//
//  UHotKeyTextField.h
//
//  Created by chao on 7/28/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UHotKeyTextFieldDelegate.h"

@class HotKey;
@protocol UMessageDelegate;

@interface UHotKeyTextField : NSTextField

@property (strong) HotKey *hotKey;
@property (strong) id<UHotKeyTextFieldDelegate> hotKeyFieldDelegate;

- (void)setUMessageDelegate:(id<UMessageDelegate>)delegate;
- (void)restoreHotKeyMode;

@end
