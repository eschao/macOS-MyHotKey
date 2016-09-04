//
//  UAppPrefViewcontroller.h
//
//  Created by chao on 8/11/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../UMessageDelegate.h"
#import "../UHotKeyTextFieldDelegate.h"

@interface UAppPrefViewController : NSViewController <
                                    NSTableViewDelegate,
                                    NSTableViewDataSource,
                                    NSTextFieldDelegate,
                                    NSTextDelegate,
                                    UHotKeyTextFieldDelegate,
                                    UMessageDelegate>

- (instancetype)init;

@end
