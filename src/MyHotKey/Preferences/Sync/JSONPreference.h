//
//  JSONPreference.h
//
//  Created by chao on 8/20/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
    SyncToCloud     = 1,
    SyncFromCloud   = -1,
    NoSync          = 0,
} SyncFlag;

@interface JSONPreference : NSObject

- (instancetype)init;
- (BOOL)readJSONWithURL:(NSURL *)url;
- (BOOL)readJSONFromData:(NSData *)data;
- (SyncFlag)checkIfNeedSync;
- (BOOL)syncToLocal:(NSError **)error;
- (NSData *)syncFromLocal:(NSError **)error;
- (NSString *)getTempFile;

@end
