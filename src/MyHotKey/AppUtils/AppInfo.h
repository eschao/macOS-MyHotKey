//
//  AppInfo.h
//
//  Created by chao on 8/11/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppInfo : NSObject

@property (strong, readonly) NSString   *appUrl;
@property (strong, readonly) NSString   *appName;
@property (strong, readonly) NSString   *appIcon;
@property (strong, readonly) NSString   *appID;
@property (strong, readonly) NSString   *appExecutable;
@property (strong, readonly) NSString   *appType;
@property BOOL isInstalled; 

- (instancetype)initWith:(NSString *)url
                 appName:(NSString *)name
                 appIcon:(NSString *)icon
                   appID:(NSString *)identity
           appExecutable:(NSString *)executable
                 appType:(NSString *)type
             isInstalled:(BOOL)isInstalled;

- (instancetype)initWithName:(NSString *)name
                       appID:(NSString *)identity;

- (NSBundle *)getBundle;
- (NSString *)getIconPath;
- (BOOL)launch;
@end
