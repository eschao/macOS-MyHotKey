//
//	WindowListData.m
//
//	Created by chao on 7/9/16.
//	Copyright © 2016 eschao. All rights reserved.
//

#import "WindowListData.h"
#import "../Utils/Constants.h"

@interface WindowListData()

@end

@implementation WindowListData

- (instancetype)init {
	if (self = [super init]) {
		self.dictArray = [[NSMutableArray alloc] init];
		self.order = 0;
	}

	return self;
}

- (void)clearAll {
	[self.dictArray removeAllObjects];
	self.order = 0;
}

- (void)debug {
	int i = 0;
	NSMutableString *output = [[NSMutableString alloc] init];

	for (NSMutableDictionary *dict in self.dictArray) {
		[output appendFormat:@"Window [%d]:\n", i++];
		[output appendFormat:@"    App Name    : %@\n", dict[appNameKey]];
		[output appendFormat:@"    App PID     : %@\n", dict[appPIDKey]];
		[output appendFormat:@"    Window Size : %@\n", dict[windowSizeKey]];
		[output appendFormat:@"    Window ID   : %@\n", dict[windowIDKey]];
		[output appendFormat:@"    Window Level: %@\n", dict[windowLevelKey]];
		[output appendFormat:@"    Window Order: %@\n", dict[windowOrderKey]];
	}

	NSLog(@"%@", output);
}

@end
