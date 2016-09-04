//
//  iCloudSync.h
//
//  Created by chao on 8/18/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CloudSync.h"
#import "CloudSyncDelegate.h"

@interface iCloudSync : NSObject<CloudSync>

@property (weak) id<CloudSyncDelegate> delegate;

- (instancetype)initWithDelegate:(id)delegate;

@end
