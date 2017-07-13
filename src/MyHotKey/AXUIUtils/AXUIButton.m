//
//	AXUIButton.m
//
//	Created by chao on 7/13/16.
//	Copyright © 2016 eschao. All rights reserved.
//

#import "AXUIButton.h"

@implementation AXUIButton

- (instancetype)initWithElement:(id)element {
	if (self = [super initWithElement:element]) {
	}

	return self;
}

- (NSString*)getTitle {
	return [self getStrValueOfAttrName:NSAccessibilityTitleAttribute];
}

- (BOOL)click {
	return [self performAction:NSAccessibilityPressAction];
}

- (BOOL)cancel {
	return [self performAction:NSAccessibilityCancelAction];
}

@end
