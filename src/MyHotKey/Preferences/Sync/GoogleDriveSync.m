//
//  GoogleDriveSync.m
//
//  Created by chao on 8/22/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "GoogleDriveSync.h"
#import "GTLR/GTLRUtilities.h"
#import "GTLRDriveService.h"
#import "GTLR/GTMOAuth2Authentication.h"
#import "GTLR/GTMOAuth2WindowController.h"
#import "GTLRDrive.h"
#import "JSONPreference.h"

NSString * const GoogleClientID = @"806033885147-vuif5m0sic50h33vjqb403n5miffgkng.apps.googleusercontent.com";
NSString * const GoogleClientSecret = @"";
NSString * const kKeychainItemName = @"GoogleDriveSync";
NSString * const CloudPreferenceName = @"com.eschao.MyHotKey.preference";

@interface GoogleDriveSync()

@property (nonatomic, readonly) GTLRDriveService *driveService;
@property (nonatomic, strong) GTLRDrive_File *preferenceFile;
@property (nonatomic, strong) JSONPreference *jsonPreference;
@property (weak) NSWindow* window;
@property (readwrite) kCloudSyncType type;

@end

@implementation GoogleDriveSync

- (instancetype)initWithWindow:(NSWindow *)window
                      delegate:(id)delegate {
    if (self = [super init]) {
        self.window = window;
        self.delegate = delegate;
        self.type = kGoogleDriveSync;
        self.jsonPreference = [[JSONPreference alloc] init];
        
        [self loadOAuth2TokenFromKeyChain];
    }

    return self;
}

- (GTLRDriveService *)driveService {
    static GTLRDriveService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[GTLRDriveService alloc] init];
        service.shouldFetchNextPages = YES;
        service.retryEnabled = YES;
    });
    
    return service;
}

- (void)loadOAuth2TokenFromKeyChain {
    GTMOAuth2Authentication *auth = [GTMOAuth2WindowController
                        authForGoogleFromKeychainForName:kKeychainItemName
                                                clientID:GoogleClientID
                                            clientSecret:GoogleClientSecret];
    self.driveService.authorizer = auth;
}

- (void)setup {
    // nothing to do
}

- (void)tearDown {
   // nothing to do
}

- (BOOL)isSignedIn {
    return (self.driveService.authorizer != nil
            && self.driveService.authorizer.canAuthorize
            && self.driveService.authorizer.userEmail != nil);
}

- (void)initGoogleDriveService {
    GTMOAuth2Authentication *auth = [GTMOAuth2WindowController
                            authForGoogleFromKeychainForName:kKeychainItemName
                                                    clientID:GoogleClientID
                                                clientSecret:GoogleClientSecret];
    self.driveService.authorizer = auth;
}

- (void)signIn {
    if (![self isSignedIn]) {
        [self signInGoogle];
    }
}

- (void)signOut {
    [GTMOAuth2WindowController removeAuthFromKeychainForName:kKeychainItemName];
    self.driveService.authorizer = nil;
    if (self.delegate) {
        [self.delegate didSignOut:nil];
    }
}

- (void)signInGoogle {
    NSBundle *frameworkBundle = [NSBundle bundleForClass:
                                [GTMOAuth2WindowController class]];
    GTMOAuth2WindowController *oauth2UI = [
        GTMOAuth2WindowController controllerWithScope:kGTLRAuthScopeDrive
                                             clientID:GoogleClientID
                                         clientSecret:GoogleClientSecret
                                     keychainItemName:kKeychainItemName
                                       resourceBundle:frameworkBundle];

    [oauth2UI signInSheetModalForWindow:self.window
                      completionHandler:^(GTMOAuth2Authentication *auth,
                                          NSError *signInError) {
            if (signInError == nil) {
                self.driveService.authorizer = auth;
            }
                          
            if (self.delegate) {
                [self.delegate didSignIn:signInError];
            }
        }];
}

- (void)sync {
    GTLRDriveQuery_FilesList *query = [GTLRDriveQuery_FilesList query];
    query.q = [NSString stringWithFormat:@"name = '%@'", CloudPreferenceName];
    [self.driveService executeQuery:query
                  completionHandler:^(GTLRServiceTicket *callbackTicket,
                                      GTLRDrive_FileList *fileList,
                                      NSError *callbackError) {
                      if (callbackError != nil) {
                          NSLog(@"Google Drive: Failed to get files: %@",
                                callbackError);
                          if (self.delegate) {
                              [self.delegate didSync:callbackError];
                          }
                      }
                      else if (fileList != nil) {
                          if (fileList.files.count < 1) {
                              [self uploadPreferences];
                          }
                          else {
                              GTLRDrive_File *file = [fileList.files
                                                       objectAtIndex:0];
                              [self updatePreferences:file];
                          }
                      }
                      else {
                          NSLog(@"Can't query file list from Google drive!");
                      }
                  }];
}

- (void)uploadPreferences {
    NSError *error;
    NSData *data = [self.jsonPreference syncFromLocal:&error];
    if (error) {
        NSLog(@"Can't upload preference to Google Drive");
        if (self.delegate) {
            [self.delegate didSyncToCloud:error];
        }
        return;
    }
    
    GTLRUploadParameters *uploadParameters = [GTLRUploadParameters
                        uploadParametersWithData:data
                                        MIMEType:@"binary/octet-stream"];
    GTLRDrive_File *newFile = [GTLRDrive_File object];
    newFile.name = CloudPreferenceName;
    GTLRDriveQuery_FilesCreate *query = [GTLRDriveQuery_FilesCreate
                        queryWithObject:newFile
                       uploadParameters:uploadParameters];
    [self.driveService executeQuery:query
                  completionHandler:^(GTLRServiceTicket *callbackTicket,
                                      GTLRDrive_File *uploadedFile,
                                      NSError *callbackError) {
                      if (self.delegate) {
                          [self.delegate didSyncToCloud:callbackError];
                      }
                  }];
}

- (void)updatePreferences:(GTLRDrive_File *)cloudPreferences {
    GTLRQuery *query = [GTLRDriveQuery_FilesGet
                        queryForMediaWithFileId:cloudPreferences.identifier];
    [self.driveService executeQuery:query
                  completionHandler:^(GTLRServiceTicket *callbackTicket,
                                      GTLRDataObject *object,
                                      NSError *callbackError) {
            if (callbackError == nil) {
                NSError *error = nil;
                if ([self.jsonPreference readJSONFromData:object.data]) {
                    SyncFlag flag = [self.jsonPreference checkIfNeedSync];
                    if (flag == kSyncFromCloud) {
                        [self.jsonPreference syncToLocal:&error];
                        if (error != nil) {
                            NSLog(@"Failed to sync from cloud: %@", error);
                        }
                        if (self.delegate) {
                            [self.delegate didSyncFromCloud:error];
                        }
                    }
                    else if (flag == kSyncToCloud) {
                        [self syncToGoogleDrive:cloudPreferences];
                    }
                }
                else if (self.delegate) {
                    [self.delegate didSync:error];
                }
            }
            else {
                NSLog(@"Fialed to sync: %@", callbackError);
                if (self.delegate) {
                    [self.delegate didSync:callbackError];
                }
            }
      }];
}

- (void)syncToGoogleDrive:(GTLRDrive_File *)cloudPreference {
    NSError *error = nil;
    NSData *data = [self.jsonPreference syncFromLocal:&error];
    if (error) {
        NSLog(@"Failed to sync to Google drive: %@", error);
        if (self.delegate) {
            [self.delegate didSyncToCloud:error];
        }
        return;
    }
    
    GTLRUploadParameters *uploadParameters = [GTLRUploadParameters
                        uploadParametersWithData:data
                                        MIMEType:@"binary/octet-stream"];
    GTLRDriveQuery_FilesUpdate *query = [GTLRDriveQuery_FilesUpdate
                                     queryWithObject:cloudPreference
                                              fileId:cloudPreference.identifier
                                    uploadParameters:uploadParameters];
    
    [self.driveService executeQuery:query
                  completionHandler:^(GTLRServiceTicket *callbackTicket,
                                      GTLRDrive_File *uploadedFile,
                                      NSError *callbackError) {
                        if (self.delegate) {
                            [self.delegate didSyncToCloud:callbackError];
                        }
                  }];
}
@end
