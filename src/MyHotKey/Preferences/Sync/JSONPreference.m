//
//  JSONPreference.m
//
//  Created by chao on 8/20/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "JSONPreference.h"
#import "../../Utils/Constants.h"
#import "../../HotKey/HotKey.h"
#import "../../HotKey/MyWindowHotKeys.h"
#import "../../HotKey/WindowHotKey.h"
#import "../../HotKey/MyAppHotKeys.h"
#import "../../HotKey/AppHotKey.h"
#import "../../AppUtils/AppInfo.h"

/*
    {
        {"update" : "123423"},
        {"WindowHotKeys" :
            { "2GridLeft" :
                {
                    "hotkey" : "ctrl shift t",
                    "enabled" : "YES"
                },
              ...
            }
        },
        {"AppHotKeys" :
            { "com.emacs" :
                {
                    "name" : "Emacs",
                    "hotkey" : "ctrl cmd g"
                },
                ...
            }
        }
    }


 */

@interface JSONPreference()

@property double cloudUpdateDate;
@property NSDictionary *jsonData;

@end

@implementation JSONPreference

- (instancetype)init {

    if (self = [super init]) {
        self.cloudUpdateDate = 0.0;
        self.jsonData = nil;
    }

    return self;
}

- (SyncFlag)checkIfNeedSync {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double date = [userDefaults doubleForKey:UpdateDateKey];

    if (date > self.cloudUpdateDate) {
        return kSyncToCloud;
    }
    else if (date < self.cloudUpdateDate) {
        return kSyncFromCloud;
    }
    else {
        return kNoSync;
    };
}

- (BOOL)syncToLocal:(NSError **)errorPtr {
    if (self.jsonData == nil) {
        NSLog(@"No JSON data need to sync to local preferences");
        return NO;
    } 

    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *cloudWinHotKeys = [self.jsonData
                                     objectForKey:MyWindowHotKeysKey];
    NSDictionary *cloudAppHotKeys = [self.jsonData
                                     objectForKey:MyAppHotKeysKey];
    NSDictionary *cloudSyncPrefs = [self.jsonData
                                       objectForKey:CloudSyncKey];
    
    if (cloudWinHotKeys == nil || cloudAppHotKeys == nil) {
        NSLog(@"Can't sync preference from cloud since the data is broken");
        return NO;
    }
    
    [userDefaults removePersistentDomainForName:appDomain];
    [userDefaults setDouble:self.cloudUpdateDate forKey:UpdateDateKey];
    
    if (cloudWinHotKeys != nil) {
        [userDefaults setObject:cloudWinHotKeys forKey:MyWindowHotKeysKey];
    }
    
    if (cloudAppHotKeys == nil) {
        [userDefaults removeObjectForKey:MyAppHotKeysKey];
    }
    else {
        [userDefaults setObject:cloudAppHotKeys forKey:MyAppHotKeysKey];
    }

    if (cloudSyncPrefs == nil) {
        [userDefaults removeObjectForKey:AutoSyncKey];
        [userDefaults removeObjectForKey:SyncAccountTypeKey];
    }
    else {
        NSString *value = [cloudSyncPrefs objectForKey:AutoSyncKey];
        [userDefaults setBool:[value boolValue] forKey:AutoSyncKey];
        [userDefaults setObject:[cloudSyncPrefs objectForKey:SyncAccountTypeKey]
                         forKey:SyncAccountTypeKey];
    }
    return YES;
}

- (NSData *)syncFromLocal:(NSError **)errorPtr {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    
    [json setObject:[userDefaults stringForKey:UpdateDateKey]
             forKey:UpdateDateKey];
    [json setObject:[userDefaults dictionaryForKey:MyWindowHotKeysKey]
             forKey:MyWindowHotKeysKey];
    
    NSDictionary *myAppHotKeys = [userDefaults dictionaryForKey:MyAppHotKeysKey];
    if (myAppHotKeys != nil) {
        [json setObject:myAppHotKeys forKey:MyAppHotKeysKey];
    }

    NSDictionary *syncPrefs = @ {
               AutoSyncKey : [userDefaults objectForKey:AutoSyncKey],
        SyncAccountTypeKey : [userDefaults objectForKey:SyncAccountTypeKey]
    };
    [json setObject:syncPrefs forKey:CloudSyncKey];

    NSError *error = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:json
                                                    options:0
                                                      error:&error];
    if (error != nil) {
        NSLog(@"Can't convert JSON to data: %@", error);
        if (errorPtr) {
            *errorPtr = error;
        }
    }
    return data;
}

- (BOOL)readJSONWithURL:(NSURL *)url {
    NSError *error = nil;
    NSData *data = [[NSData alloc] initWithContentsOfURL:url
                                                 options:NSDataReadingUncached
                                                   error:&error];
    if (error != nil) {
        NSLog(@"Can't read content from URL: %@, Error: %@", url, error);
        return NO;
    }
    
    return [self readJSONFromData:data];
}

- (BOOL)readJSONFromData:(NSData *)data {
    NSError *error = nil;
    self.jsonData = [NSJSONSerialization
                        JSONObjectWithData:data
                                   options:NSJSONReadingMutableContainers
                                     error:&error];
    if (error != nil) {
        NSLog(@"Can't parse json data: %@", error);
        return NO;
    }

    NSString *date = [self.jsonData objectForKey:UpdateDateKey];
    if (data == nil) {
        NSLog(@"Can't get update date value from json data!");
        return NO;
    }

    self.cloudUpdateDate = [date doubleValue];
    if (self.cloudUpdateDate < 1) {
        NSLog(@"It seems update date from JSON data is invalid!");
    }

    return YES;
}

- (NSString *)getTempFile {
    NSString *tempDir = NSTemporaryDirectory();
    if (tempDir == nil) {
        tempDir = @"/tmp";
    }

    return [tempDir stringByAppendingPathComponent:
            @"com.eschao.MyHotKey.preferences.json"];
}

@end
