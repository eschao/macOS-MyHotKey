//
//  USyncPrefViewController.m
//
//  Created by chao on 8/23/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "USyncPrefViewController.h"
#import "GoogleDriveSync.h"
#import "iCloudSync.h"
#import "../../Utils/Constants.h"
#import "../../Utils/PreferenceUtil.h"

const int iCloudAccountIndex = 0;
const int GoogleAccountIndex = 1;

@interface USyncPrefViewController()

@property (strong) id<CloudSync> syncDelegate;
@property (weak) IBOutlet NSComboBox *accountComboBox;
@property (weak) IBOutlet NSButton *syncAtStartButton;
@property (weak) IBOutlet NSTextField *lastSyncTextField;
@property (weak) IBOutlet NSTextField *syncStatusTextField;
@property (weak) IBOutlet NSButton *signInOutButton;
@property (weak) IBOutlet NSButton *syncButton;
@property (weak) IBOutlet NSProgressIndicator *syncProgressIndicator;
@property (weak) NSWindow *window;
@property BOOL isDataChanged;

@end

@implementation USyncPrefViewController

- (instancetype)initWithWindow:(NSWindow *)window {
    if (self = [super initWithNibName:@"SyncPreference" bundle:nil]) {
        self.window = window;
        self.isDataChanged = NO;
    }

    return self;
}

- (void)viewDidLoad {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *accountType = [userDefaults objectForKey:SyncAccountTypeKey];
        
    if ([accountType isEqualToString:@"iCloud"]) {
        self.syncDelegate = [[iCloudSync alloc] initWithDelegate:self];
        [self.accountComboBox selectItemAtIndex:iCloudAccountIndex];
            
        if (accountType == nil) {
            [userDefaults setObject:@"iCloud" forKey:SyncAccountTypeKey];
        }
    }
    else if ([accountType isEqualToString:@"Google Drive"]) {
        self.syncDelegate = [[GoogleDriveSync alloc] initWithWindow:self.window
                                                           delegate:self];
        [self.accountComboBox selectItemAtIndex:GoogleAccountIndex];
    }
    else {
        NSLog(@"Can't support sync type: %@", accountType);
    }
}

- (void)viewWillAppear {
    if (self.syncDelegate) {
        [self.syncDelegate setup];
        [self updateUIByCloudVendor];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:SyncAtStartKey]) {
        [self.syncAtStartButton setState:NSOnState];
    }
    else {
        [self.syncAtStartButton setState:NSOffState];
    }
    
    NSString *lastSyncDate = [NSString stringWithFormat:@"Last update: %@",
                                [userDefaults objectForKey:LastSyncDateKey]];
    [self.lastSyncTextField setStringValue:lastSyncDate];
}

- (void)viewWillDisappear {
    if (self.syncDelegate) {
        [self.syncDelegate tearDown];
    }

    if (self.isDataChanged) {
        BOOL isOn = [self.syncAtStartButton state] == NSOnState;
        NSString *cloudType = nil;
        
        if (self.accountComboBox.indexOfSelectedItem == iCloudAccountIndex) {
            cloudType = @"iCloud";
        }
        else if (self.accountComboBox.indexOfSelectedItem == GoogleAccountIndex)
        {
            cloudType = @"Google Drive";
        }
        
        [PreferenceUtil saveSyncPreferences:isOn cloudType:cloudType];
    }
}

- (IBAction)onSignInOut:(id)sender {
    if (self.syncDelegate) {
        if (self.syncDelegate.type != kiCloudSync) {
            [self.signInOutButton setEnabled:NO];
        }

        if ([self.syncDelegate isSignedIn]) {
            [self.syncDelegate signOut];

            if (self.syncDelegate.type != kiCloudSync) {
                [self.syncButton setEnabled:NO];
            }
        }
        else {
            [self.syncDelegate signIn];
        }
    }
}

- (IBAction)onSync:(id)sender {
    if (self.syncDelegate != nil && [self.syncDelegate isSignedIn]) {
        [self.syncButton setEnabled:NO];
        [self.syncProgressIndicator setHidden:NO];
        [self.syncDelegate sync];
    }
}

- (IBAction)onSyncAtStart:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isOn = [self.syncAtStartButton state] == NSOnState;
    if ([userDefaults boolForKey:SyncAtStartKey] != isOn) {
        self.isDataChanged = YES;
    }
}

- (void)completedAction:(CloudSyncAction)action
                  error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (action == SignInAction) {
            [self.signInOutButton setEnabled:YES];
            if (error == nil) {
                [self.signInOutButton setTitle:@"Sign Out"];
                [self.syncButton setEnabled:YES];
            }
            else {

            }
        }
        else if (action == SignOutAction) {
            [self.signInOutButton setEnabled:YES];
            if (error == nil) {
                [self.signInOutButton setTitle:@"Sign In"];
                [self.syncButton setEnabled:NO];
            }
            else {

            }
        }
        else if (action == SyncAction) {
            [self.syncButton setEnabled:YES];
            [self.syncProgressIndicator stopAnimation:self];

            if (error != nil) {
                [self.syncStatusTextField setStringValue:[NSString
                        stringWithFormat:@"Can't sync preferences! Error: %@",
                                                [error localizedDescription]]];
            }
        }
        else if (action == CompleteSyncAction) {
            [self handleCompleteSyncAction:error];
        }
    });
}

- (void)handleCompleteSyncAction:(NSError *)error {
    [self.syncButton setEnabled:YES];
    [self.syncProgressIndicator stopAnimation:self];

    if (error != nil) {
        [self.syncStatusTextField setStringValue:[NSString
        stringWithFormat:@"Can't complete sync preferences! Error: %@",
                            [error localizedDescription]]];
    }
    else {
        // update sync time
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *syncDate = [dateFormatter stringFromDate:[NSDate date]];
        [self.lastSyncTextField setStringValue:[NSString
                            stringWithFormat:@"Last update: %@", syncDate]];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

        // update sync at start button state
        [userDefaults setObject:syncDate forKey:LastSyncDateKey];
        if ([userDefaults boolForKey:SyncAtStartKey]) {
            [self.syncAtStartButton setState:NSOnState];
        }
        else {
            [self.syncAtStartButton setState:NSOffState];
        }

        // update cloud type
        NSString *cloudType = [userDefaults objectForKey:SyncAccountTypeKey];
        if (cloudType == nil) {
            NSLog(@"Null sync cloud type after synced with cloud!");
        }
        else if ([cloudType isEqualToString:@"iCloud"]) {
            [self.accountComboBox selectItemAtIndex:iCloudAccountIndex];    
        }
        else if ([cloudType isEqualToString:@"Google Drive"]) {
            [self.accountComboBox selectItemAtIndex:GoogleAccountIndex]; 
        }
    }
    
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (self.accountComboBox.indexOfSelectedItem == iCloudAccountIndex) {
        if (self.syncDelegate == nil
            || self.syncDelegate.type != kiCloudSync) {
            if (self.syncDelegate) {
                [self.syncDelegate tearDown];
            }

            self.syncDelegate = [[iCloudSync alloc] initWithDelegate:self];
            [userDefaults setObject:@"iCloud" forKey:SyncAccountTypeKey];
            [self.syncDelegate setup];
            [self updateUIByCloudVendor];
        }
    }
    else if (self.accountComboBox.indexOfSelectedItem == GoogleAccountIndex) {
        if (self.syncDelegate == nil
            || self.syncDelegate.type != kGoogleDriveSync) {
            if (self.syncDelegate) {
                [self.syncDelegate tearDown];
            }

            self.syncDelegate = [[GoogleDriveSync alloc]
                                 initWithWindow:self.window delegate:self];
            [userDefaults setObject:@"Google Drive" forKey:SyncAccountTypeKey];
            [self.syncDelegate setup];
            [self updateUIByCloudVendor];
        }
    }
}

- (void)updateUIByCloudVendor {
    if ([self.syncDelegate isSignedIn]) {
        [self.signInOutButton setTitle:@"Sign Out"];
        [self.syncButton setEnabled:YES];
    }
    else {
        [self.signInOutButton setTitle:@"Sign In"];
        [self.syncButton setEnabled:NO];
    }
    
    [self.signInOutButton setEnabled:YES];
}

@end
