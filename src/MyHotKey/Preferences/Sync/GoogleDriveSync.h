//
//  GoogleDriveSync.h
//
//  Created by chao on 8/22/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CloudSync.h"
#import "CloudSyncDelegate.h"

@interface GoogleDriveSync : NSObject<CloudSync>

@property (weak) id<CloudSyncDelegate> delegate;

- (instancetype)initWithWindow:(NSWindow *)window
                      delegate:(id)delegate;

@end
