//
//	AppInfo.m
//
//	Created by chao on 8/11/16.
//	Copyright © 2016 eschao. All rights reserved.
//

#import "AppInfo.h"

@interface AppInfo()

@property (nonatomic, strong, readwrite) NSString  *appUrl;
@property (nonatomic, strong, readwrite) NSString  *appName;
@property (nonatomic, strong, readwrite) NSString  *appIcon;
@property (nonatomic, strong, readwrite) NSString  *appID;
@property (nonatomic, strong, readwrite) NSString  *appExecutable;
@property (nonatomic, strong, readwrite) NSString  *appType;

@end

@implementation AppInfo

- (instancetype)initWith:(NSString *)url
								 appName:(NSString *)name
								 appIcon:(NSString *)icon
									 appID:(NSString *)identity
					 appExecutable:(NSString *)executable
								 appType:(NSString *)type
						 isInstalled:(BOOL)isInstalled {
	if (self = [super init]) {
		self.appUrl = url;
		self.appName = name;
		self.appIcon = icon;
		self.appID = identity;
		self.appExecutable = executable;
		self.appType = type;
		self.isInstalled = isInstalled;
	}

	return self;
}

- (instancetype)initWithName:(NSString *)name
											 appID:(NSString *)identity {
	if (self = [super init]) {
		self.appUrl = nil;
		self.appName = name;
		self.appIcon = nil;
		self.appID = identity;
		self.appExecutable = nil;
		self.appType = nil;
		self.isInstalled = false;
	}

	return self;
}

- (NSBundle *)getBundle {
	if (self.appUrl) {
		return [NSBundle bundleWithURL:[NSURL URLWithString:self.appUrl]];
	}

	return nil;
}

- (NSString *)getIconPath {
	if (self.appUrl && self.appIcon) {
		NSString *iconPath = [
			NSString stringWithFormat:@"%@/Contents/Resources/%@", self.appUrl,
			self.appIcon];
		if ([[NSFileManager defaultManager] fileExistsAtPath:iconPath]) {
			return iconPath;
		}

		return [NSString stringWithFormat:@"%@.icns", iconPath];
	}

	return nil;
}

- (BOOL)launch {
	if (self.isInstalled) {
		return [[NSWorkspace sharedWorkspace] launchApplication:self.appName];
	}
	else {
		NSLog(@"Application %@ is not installed!", self.appName);
	}

	return NO;
}

@end
