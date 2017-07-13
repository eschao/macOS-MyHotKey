//
//	ScreenUtils.m
//
//	Created by chao on 7/13/16.
//	Copyright © 2016 eschao. All rights reserved.
//

#import "ScreenUtils.h"

@implementation ScreenUtils

+ (CGSize)getMainScreenSize {
	NSScreen *screen = [NSScreen mainScreen];
	return screen.frame.size;
}

+ (CGRect)getMainScreenRect {
	NSScreen *screen = [NSScreen mainScreen];
	return screen.frame;
}

+ (CGSize)getVisibleScreenSize {
	NSScreen *screen = [NSScreen mainScreen];
	return screen.visibleFrame.size;
}

+ (CGRect)getVisibleScreenRect {
	NSScreen *screen = [NSScreen mainScreen];
	CGRect rect = screen.visibleFrame;
	rect.origin.y = screen.frame.size.height - rect.size.height - rect.origin.y;
	return rect;
}

@end
