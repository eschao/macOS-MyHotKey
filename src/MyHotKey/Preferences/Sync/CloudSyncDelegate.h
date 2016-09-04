//
//  CloudSyncDelegate.h
//
//  Created by chao on 8/21/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
    SignInAction = 0,
    SignOutAction,
    SyncAction,
    CompleteSyncAction,
}CloudSyncAction;

@protocol CloudSyncDelegate

- (void)completedAction:(CloudSyncAction)action
                  error:(NSError *)error;

@end
