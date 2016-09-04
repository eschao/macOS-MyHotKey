//
//  UAddAppHotKeyDialog.h
//
//  Created by chao on 8/13/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UHotKeyTextFieldDelegate.h"

@class UHotKeyTextField;

@interface UAddAppHotKeyDialog : NSWindowController <UHotKeyTextFieldDelegate>

@property (weak) IBOutlet UHotKeyTextField *hotKeyTextField;
@property (weak) IBOutlet NSPopUpButton *appsList;

- (instancetype)init;

@end
