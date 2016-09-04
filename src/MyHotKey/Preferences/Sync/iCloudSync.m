//
//  iCloudSync.m
//
//  Created by chao on 8/18/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "iCloudSync.h"
#import "JSONPreference.h"
#import "Constants.h"

NSString * const QUERY_STMT = @"%K LIKE '*'";

@interface iCloudSync()

@property (strong) NSURL            *ubiquitousURL;
@property (strong) NSMetadataQuery  *metadataQuery;
@property (strong) JSONPreference   *jsonPreference;
@property (readwrite) kCloudSyncType type;

@end

@implementation iCloudSync

- (instancetype)initWithDelegate:(id)delegate {
    if (self = [super init]) {
        self.ubiquitousURL = nil;        
        self.metadataQuery = nil;
        self.jsonPreference = [[JSONPreference alloc] init];
        self.delegate = delegate;
        self.type = kiCloudSync;
    }

    return self;
}

- (void)setup {
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(checkiCloudStatus)
               name:NSUbiquityIdentityDidChangeNotification
             object:nil];
}

- (void)tearDown {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)sync {
    NSURL *iCloudURL = [self.ubiquitousURL URLByAppendingPathComponent:
                                CloudPreferenceFile];
    NSURL *localURL = [NSURL fileURLWithPath:[self.jsonPreference getTempFile]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^(void) {
            NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc]
                                                    initWithFilePresenter:nil];
            NSError *error = nil;
            [fileCoordinator
                coordinateReadingItemAtURL:iCloudURL
                                   options:NSFileCoordinatorReadingWithoutChanges
                                     error:&error
                                byAccessor:^(NSURL *newURL) {
                if (error == nil) {
                    NSFileManager *fileMgr = [[NSFileManager alloc] init];
                    NSError *err = nil;
                    [fileMgr removeItemAtURL:localURL error:nil];
                    
                    if (![fileMgr fileExistsAtPath:[iCloudURL path]]) {
                        [self syncToCloud];
                    }
                    else if ([fileMgr copyItemAtURL:iCloudURL
                                         toURL:localURL
                                         error:&err]) {
                        if (![self.jsonPreference readJSONWithURL:localURL]) {
                            NSLog(@"Failed to read JSON data from temp file");
                            [self syncToCloud];
                        }
                        else {
                            SyncFlag flag = [self.jsonPreference
                                                checkIfNeedSync];
                            if (flag == SyncToCloud) {
                                [self syncToCloud];
                            }
                            else if (flag == SyncFromCloud) {
                                [self syncFromCloud];
                            }
                            else if (self.delegate) {
                                [self.delegate
                                 completedAction:CompleteSyncAction error:nil];
                            }
                        }
                    }
                    else if (err != nil) {
                        NSLog(@"Can't read JSON preference from iCloud");
                        if (self.delegate) {
                            [self.delegate completedAction:SyncAction
                                                     error:err];
                        }
                    }
                }
                else {
                    NSLog(@"Can't coordinate read JSON preference from iCloud: "
                          "%@", error);
                    if (self.delegate) {
                        [self.delegate completedAction:SyncAction
                                                 error:error];
                    }
                }
            }];
        });
}

- (void)syncToCloud {
    NSError *error = nil;
    NSData *data = [self.jsonPreference syncFromLocal:&error];
    if (error != nil) {
        if (self.delegate) {
            [self.delegate completedAction:SyncAction error:error];
        }
        
        return;
    }
    
    NSURL *iCloudURL = [self.ubiquitousURL URLByAppendingPathComponent:
                                CloudPreferenceFile];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^(void) {
            NSError *error = nil;
            NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc]
                                                    initWithFilePresenter:nil];
            [fileCoordinator
                coordinateWritingItemAtURL:iCloudURL
                                   options:NSFileCoordinatorWritingForReplacing
                                     error:&error
                                byAccessor:^(NSURL *newURL) {
                    NSError *err = nil;
                    if (![data writeToURL:iCloudURL
                                  options:NSDataWritingAtomic
                                    error:&err] || err != nil) {
                        NSLog(@"Can't write to temp file: %@", err);
                    }
                                    
                    if (self.delegate) {
                        [self.delegate completedAction:CompleteSyncAction
                                                 error:err];
                    }
            }];
                       
            if (error != nil) {
                NSLog(@"Can't coordinate write to iCloud: %@", error);
                if (self.delegate) {
                    [self.delegate completedAction:CompleteSyncAction
                                             error:error];
                }
            }
           });
}

- (void)syncFromCloud {
    NSError *error = nil;
    if (![self.jsonPreference syncToLocal:&error]) {
        NSLog(@"Can't sync from iCloud. Error: %@", error);
    }
    
    if (self.delegate) {    
        [self.delegate completedAction:SyncAction error:error];
    }
}

- (BOOL)isSignedIn {
    self.ubiquitousURL = [[NSFileManager defaultManager]
                             URLForUbiquityContainerIdentifier:nil];
    if (self.ubiquitousURL == nil) {
        return NO;
    }
    
    return YES;
}

- (void)signIn {
    [self openSysiCloudPrefs];
}

- (void)signOut {
    [self openSysiCloudPrefs];
}

- (void)openSysiCloudPrefs {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL fileURLWithPath:
                    @"/System/Library/PreferencePanes/iCloudPref.prefPane"]];
}

- (void)checkIfExistIniCloud {
    self.metadataQuery = [[NSMetadataQuery alloc] init];
    [self.metadataQuery setPredicate:[NSPredicate
                                      predicateWithFormat:QUERY_STMT,
                                      NSMetadataItemFSNameKey]];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(iCloudQueryDidReceiveNotification:)
               name:NSMetadataQueryDidUpdateNotification
             object:self.metadataQuery];
}

- (void)iCloudQueryDidReceiveNotification:(NSNotification *)notification {
    NSArray *results = [self.metadataQuery results];
    if (results.count > 0) {
        NSMetadataItem *item = [results objectAtIndex:0];
        NSString *fileURL = [item valueForAttribute:NSMetadataItemURLKey];
        if (fileURL == nil) {
            
        }

    }
}

- (void)checkiCloudStatus {
    self.ubiquitousURL = [[NSFileManager defaultManager]
                            URLForUbiquityContainerIdentifier:nil];
    if (self.delegate) {
        CloudSyncAction action = SignOutAction;
        if (self.ubiquitousURL != nil) {
            action = SignInAction;
        }
        
        [self.delegate completedAction:action error:nil];
    }
}

@end
