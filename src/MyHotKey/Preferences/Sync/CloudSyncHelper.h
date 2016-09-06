//
//  CloudSyncHelper.h
//
//  Created by chao on 9/06/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CloudSyncDelegate.h"

@interface CloudSyncHelper : NSObject<CloudSyncDelegate>

@property id delegate;

+ (instancetype)sharedHelper;
- (void)sync;

@end
