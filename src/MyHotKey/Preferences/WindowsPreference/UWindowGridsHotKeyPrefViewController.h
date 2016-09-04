//
//  UWindowGridsHotKeyPrefViewController.h
//
//  Created by chao on 7/23/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../UHotKeyTextFieldDelegate.h"

typedef NS_ENUM(NSUInteger, WindowGridsType) {
    kWindow2Grids = 0,
    kWindow3Grids,
    kWindow4Grids,
    kWindowHotKeys
};

@interface UWindowGridsHotKeyPrefViewController : NSViewController <
                                                  NSTableViewDelegate,
                                                  NSTableViewDataSource,
                                                  NSTextFieldDelegate,
                                                  NSTextDelegate,
                                                  UHotKeyTextFieldDelegate>

- (instancetype)initWith:(id)delegate;
- (void)reloadData:(WindowGridsType)type;
- (void)restoreDefaultHotKeys;

@end
