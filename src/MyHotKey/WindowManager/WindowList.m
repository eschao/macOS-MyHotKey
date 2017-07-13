//
//	WindowsList.m
//
//	Created by chao on 7/9/16.
//	Copyright © 2016 eschao. All rights reserved.
//

#import "WindowList.h"
#import "WindowListData.h"
#import "../Utils/Constants.h"
#import "../AXUIUtils/AXUIApp.h"

@interface WindowList()

@property(nonatomic) CGWindowListOption      winListOption;
@property(nonatomic, strong) WindowListData  *winListData;

void windowListApplierFunc(const void *inputDict, void *context);

@end


@implementation WindowList

- (instancetype)init {
	if (self = [super init]) {
		self.winListOption = kCGWindowListOptionOnScreenAboveWindow;
		self.winListData = [[WindowListData alloc] init];
	}

	return self;
}

void windowListApplierFunc(const void *inputDict, void *context) {
	NSDictionary *entry = (__bridge NSDictionary*)inputDict;
	WindowListData *data = (__bridge WindowListData*)context;

	int sharingState = [entry[(id)kCGWindowSharingState] intValue];
	if (sharingState != kCGWindowSharingNone) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];

		// get application name
		NSString *appName = entry[(id)kCGWindowOwnerName];
		if (appName == NULL) {
			appName = @"unknown";
		}
		dict[appNameKey] = appName;

		// get application PID
		dict[appPIDKey] = entry[(id)kCGWindowOwnerPID];

		// get window bounds
		CGRect bounds;
		CGRectMakeWithDictionaryRepresentation(
				(CFDictionaryRef)entry[(id)kCGWindowBounds], &bounds);
		dict[windowSizeKey] = [NSValue valueWithRect:bounds];

		// get window ID
		dict[windowIDKey] = entry[(id)kCGWindowNumber];

		// get window Level
		dict[windowLevelKey] = entry[(id)kCGWindowLayer];

		dict[windowOrderKey] = @(data.order);
		++data.order;
		[data.dictArray addObject:dict];
	}
}

- (void)updateWindowList {
	CFArrayRef windowList = CGWindowListCopyWindowInfo(
		self.winListOption, kCGNullWindowID);
	[self.winListData clearAll];
	CFArrayApplyFunction(windowList, CFRangeMake(
		0, CFArrayGetCount(windowList)), &windowListApplierFunc,
		(__bridge void*)(self.winListData));
	CFRelease(windowList);
	//[self.winListData debug];
	[self listAXUIAttributs];
}

- (void)listAXUIAttributs {
	NSMutableString *msg = [[NSMutableString alloc] init];

	for (NSMutableDictionary *dict in self.winListData.dictArray) {
		AXUIApp *axApp = [[AXUIApp alloc] initWithPID:
			[dict[appPIDKey] intValue]];
		NSArray *attributes = [axApp getAttributes];
		[msg appendFormat:@"App: %@", axApp.name];
		for (AXAttribute *attr in attributes) {
			[msg appendFormat:@" Attribute:[%@] -> [%@]\n", attr.name,
				[attr getValue:(__bridge AXUIElementRef)axApp.element]];
		}

		NSLog(@"%@\n", msg);
	}
}

- (void)listActiveApp {
	AXUIApp *app = [AXUIApp getFrontmostApp];
	NSMutableString *msg = [[NSMutableString alloc] init];
	NSArray *attributes = [app getAttributes];
	[msg appendFormat:@"App: %@", app.name];
	/*
		 for (AXAttribute *attr in attributes) {
		 [msg appendFormat:@"	Attribute:[%@] -> [%@]\n", attr.name,
		 [attr getValue:app.elementRef]];
		 }
		 */
	AXUIWindow *focusedWin = [app getFocusedWindow];
	if (focusedWin) {
		[msg appendFormat:@" Focused Window: %@", [focusedWin getTitle]];
	}

	NSLog(@"%@\n", msg);
}

- (void)moveFrontmostWindow {
	/*
		 AXUIApp *app = [AXUIApp getFrontmostApp];
		 AXUIWindow *focusedWin = [app getFocusedWindow];
		 if (focusedWin) {
		 CGSize size = CGSizeMake(300, 300);
		 [focusedWin setCGSizeValueForAttrName:NSAccessibilitySizeAttribute
																		 value:size];
																		 } */
	NSLog(@"move front most window");
}

@end
