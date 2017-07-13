//
//	AppUtils.m
//
//	Created by chao on 8/12/16.
//	Copyright © 2016 eschao. All rights reserved.
//

#import "AppUtils.h"
#import "AppInfo.h"


@implementation AppUtils

// Load all installed application from /Application folder
+ (void)loadInstalledApps:(NSMutableDictionary *)apps {
	NSArray *appUrls = [[NSFileManager defaultManager]
		URLsForDirectory:NSApplicationDirectory
					 inDomains:NSLocalDomainMask];
	NSError *error = nil;
	NSArray *properties = [NSArray arrayWithObjects:NSURLLocalizedNameKey,
					NSURLCreationDateKey,
					NSURLLocalizedTypeDescriptionKey, nil];

	// load all installed applications from /Application folder
	NSArray *values = [[NSFileManager defaultManager]
		contentsOfDirectoryAtURL:[appUrls objectAtIndex:0]
		includingPropertiesForKeys:properties
											 options:(NSDirectoryEnumerationSkipsHiddenFiles)
												 error:&error];
	
	// add Finder app
	NSMutableArray *all = [[NSMutableArray alloc] initWithArray: values];
	[all addObject:[NSURL fileURLWithPath:
		@"/System/Library/CoreServices/Finder.app"]];

	if (error != nil) {
		NSLog(@"Can not get properties of applications with error: %@", error);
	}
	else {
		// get every application infos
		for (NSURL *url in all) {
			NSBundle *bundle = [NSBundle bundleWithURL:url];
			if (bundle != nil) {
				// get application name
				NSString *name = [bundle
					objectForInfoDictionaryKey:@"CFBundleDisplayName"];
				if (name == nil) {
					name = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
				}
				
				// get application icon
				NSString *icon = [bundle objectForInfoDictionaryKey:
					@"CFBundleIconFile"];
				// get application executable file
				NSString *executable = [bundle objectForInfoDictionaryKey:
					@"CFBundleExecutable"];
				// get application id
				NSString *identity = [bundle objectForInfoDictionaryKey:
					@"CFBundleIdentifier"];
				// get package type
				NSString *type = [bundle objectForInfoDictionaryKey:
					@"CFBundlePackageType"];
				
				if (name == nil || identity == nil) {
					NSLog(@"Can not get name or identity for applicat: %@", url);
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
