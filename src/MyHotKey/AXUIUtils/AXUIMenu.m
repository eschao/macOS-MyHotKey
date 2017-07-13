//
//	AXUIMenu.m
//
//	Created by chao on 7/13/16.
//	Copyright © 2016 eschao. All rights reserved.
//

#import "AXUIMenu.h"

@implementation AXUIMenu

- (instancetype)initWithElement:(id)element {
	if (self = [super initWithElement:element]) {
	}

	return self;
}

- (NSString *)getTitle {
	return [self getStrValueOfAttrName:NSAccessibilityTitleAttribute];
}

- (BOOL)show {
	return [self performAction:NSAccessibilityShowMenuAction];
}

- (BOOL)pick {
	return [self performAction:NSAccessibilityPickAction];
}

@end
