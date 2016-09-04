//
//  CloudSync.h
//
//  Created by chao on 8/20/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
    kiCloudSync = 0,
    kGoogleDriveSync,
}kCloudSyncType;

@protocol CloudSync

@property (readonly) kCloudSyncType type;

- (void)sync;
- (BOOL)isSignedIn;
- (void)signIn;
- (void)signOut;
- (void)setup;
- (void)tearDown;

@end
