//
//	ScreenUtils.h
//
//	Created by chao on 7/13/16.
//	Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ScreenUtils : NSObject

+ (CGSize)getMainScreenSize;
+ (CGRect)getMainScreenRect;
+ (CGSize)getVisibleScreenSize;
+ (CGRect)getVisibleScreenRect;

@end
