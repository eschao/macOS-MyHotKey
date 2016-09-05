//
//  CloudSyncDelegate.h
//
//  Created by chao on 8/21/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CloudSyncDelegate

- (void)didSignIn:(NSError *)error;
- (void)didSignOut:(NSError *)error;
- (void)didSync:(NSError *)error;
- (void)didSyncToCloud:(NSError *)error;
- (void)didSyncFromCloud:(NSError *)error;

@end
