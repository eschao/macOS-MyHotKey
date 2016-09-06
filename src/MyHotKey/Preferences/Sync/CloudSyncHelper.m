//
//  CloudSyncHelper.m
//
//  Created by chao on 9/06/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "CloudSyncHelper.h"
#import "CloudSync.h"
#import "iCloudSync.h"
#import "GoogleDriveSync.h"
#import "../../Utils/Constants.h"
#import "../../HotKey/HotKeyManager.h"
#import "../../HotKey/MyAppHotKeys.h"
#import "../../HotKey/MyWindowHotKeys.h"

static CloudSyncHelper *_sharedHelper = nil;    
static dispatch_once_t  _onceToken;

@interface CloudSyncHelper()
    
@end

@implementation CloudSyncHelper

+ (instancetype)sharedHelper {
    dispatch_once(&_onceToken, ^{
            _sharedHelper = [[CloudSyncHelper alloc] init];
        }
        );

    return _sharedHelper;
}

- (instancetype)init {
    if (self = [super init]) {
        self.delegate = nil;
    } 

    return self;
}

- (void)sync {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id<CloudSync> syncDelegate = nil;
    NSString *accountType = [userDefaults objectForKey:SyncAccountTypeKey];
    if (accountType == nil) {
        
    }
    else if ([accountType isEqualToString:@"iCloud"]) {
        syncDelegate = [[iCloudSync alloc] initWithDelegate:self];
    }
    else if ([accountType isEqualToString:@"Google Drive"]) {
        syncDelegate = [[GoogleDriveSync alloc] initWithWindow:nil
                                                      delegate:self];
    }

    if (syncDelegate != nil && [syncDelegate isSignedIn]) {
        [syncDelegate sync];
    }
}

- (void)didSignIn:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate) {
            [self.delegate didSignIn:error];
        }
    });
}

- (void)didSignOut:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate) {
            [self.delegate didSignOut:error]; 
        }
    });
}

- (void)didSync:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate) {
            [self.delegate didSync:error];
        }
    });
}

- (void)didSyncToCloud:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate) {
            [self.delegate didSyncToCloud:error];
        }
    });
}

- (void)didSyncFromCloud:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate) {
            [self.delegate didSyncFromCloud:error];
        }

        if (error != nil) {
            [[HotKeyManager sharedManager] unbindAll];
            [[MyAppHotKeys sharedHotKeys] reloadFromPrefs];
            [[MyWindowHotKeys sharedHotKeys] reloadFromPrefs];
        }
        else {
            NSLog(@"Failed to sync from cloud: %@", error);        
        }
    });
}

@end
