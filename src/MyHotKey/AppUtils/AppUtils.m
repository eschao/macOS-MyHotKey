//
//  AppUtils.m
//
//  Created by chao on 8/12/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "AppUtils.h"
#import "AppInfo.h"


@implementation AppUtils

+ (void)loadInstalledApps:(NSMutableDictionary *)apps {
    NSArray *appUrls = [[NSFileManager defaultManager]
                           URLsForDirectory:NSApplicationDirectory
                                  inDomains:NSLocalDomainMask];
    NSError *error = nil;
    NSArray *properties = [NSArray arrayWithObjects:NSURLLocalizedNameKey,
                                   NSURLCreationDateKey,
                                   NSURLLocalizedTypeDescriptionKey, nil];

    NSArray *values = [[NSFileManager defaultManager]
            contentsOfDirectoryAtURL:[appUrls objectAtIndex:0]
          includingPropertiesForKeys:properties
                             options:(NSDirectoryEnumerationSkipsHiddenFiles)
                               error:&error];
    if (error != nil) {
        NSLog(@"Can not get properties of applications with error: %@", error);
    }
    else if (values != nil) {
        for (NSURL *url in values) {
            NSBundle *bundle = [NSBundle bundleWithURL:url];
            if (bundle != nil) {
                NSString *name = [bundle objectForInfoDictionaryKey:
                                             @"CFBundleDisplayName"];
                if (name == nil) {
                    name = [bundle objectForInfoDictionaryKey:
                                                @"CFBundleName"];
                }
                NSString *icon = [bundle objectForInfoDictionaryKey:
                                             @"CFBundleIconFile"];
                NSString *executable = [bundle objectForInfoDictionaryKey:
                                                   @"CFBundleExecutable"];
                NSString *identity = [bundle objectForInfoDictionaryKey:
                                                 @"CFBundleIdentifier"];
                NSString *type = [bundle objectForInfoDictionaryKey:
                                             @"CFBundlePackageType"];
                if (name == nil || identity == nil) {
                    NSLog(@"Can not get name or identity for applicat: %@",
                          url);
                }
                else {
                    AppInfo *app = [[AppInfo alloc] initWith:url.path
                                                     appName:name
                                                     appIcon:icon
                                                       appID:identity
                                               appExecutable:executable
                                                     appType:type
                                                 isInstalled:YES];
                    [apps setObject:app forKey:identity];
                }
            }
            else {
                NSLog(@"Can not create bundle for: %@", url);
            }
        }
    }
}

@end
