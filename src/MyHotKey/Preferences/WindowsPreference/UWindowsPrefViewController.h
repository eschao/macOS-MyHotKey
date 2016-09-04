//
//  UWindowsPrefViewController.h
//
//  Created by chao on 7/16/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../UMessageDelegate.h"

@interface UWindowsPrefViewController : NSViewController <
                                        NSTableViewDelegate,
                                        NSTableViewDataSource,
                                        UMessageDelegate >

- (instancetype)init;

@end
