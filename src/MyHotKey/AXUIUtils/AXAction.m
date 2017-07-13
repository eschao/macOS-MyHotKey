//
//	AXAction.m
//
//	Created by chao on 7/10/16.
//	Copyright © 2016 eschao. All rights reserved.
//

#import "AXAction.h"

@interface AXAction()

@property (nonatomic, strong) NSString	*desc;
@end

@implementation AXAction

- (instancetype)initWithName:(NSString *)name {
	if (self = [super init]) {
		self.name = name;
		self.desc = nil;
	}

	return self;
}

- (instancetype)initWithCName:(CFStringRef)name {
	if (self = [super init]) {
		self.name = (__bridge_transfer NSString*)name;
		self.desc = nil;
	}

	return self;
}

- (NSString *)description:(AXUIElementRef)element {
	if (self.desc == nil) {
		CFStringRef desc = NULL;
		AXUIElementCopyActionDescription(
			element,
			(__bridge CFStringRef)self.name,
			&desc);
		self.desc = (__bridge_transfer NSString*)desc;
	}

	return self.desc;
}

- (void)perform:(AXUIElementRef)element {
	AXUIElementPerformAction(element, (__bridge CFStringRef)self.name);
}

@end
