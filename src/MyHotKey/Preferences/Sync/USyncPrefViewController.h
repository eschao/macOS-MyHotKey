//
//  USyncPrefViewController.h
//
//  Created by chao on 8/23/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CloudSyncDelegate.h"

@interface USyncPrefViewController : NSViewController<
                                            CloudSyncDelegate,
                                            NSComboBoxDelegate
                                     >

- (instancetype)initWithWindow:(NSWindow *)window;

@end
