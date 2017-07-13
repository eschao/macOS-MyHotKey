// AXElement.m
//
// Created by chao on 7/10/16.
// Copyright © 2016 eschao. All rights reserved.
//

#import "AXElement.h"
#import "AXAction.h"
#import "AXAttribute.h"

@interface AXElement()

@property (readwrite) id                     element;
@property (nonatomic, strong) NSMutableArray *attributes;
@property (nonatomic, strong) NSMutableArray *actions;

@end

@implementation AXElement

- (instancetype)initWithElement:(id)element {
	if (self = [super init]) {
		self.element = element;
		self.attributes = nil;
		self.actions = nil;
		self.attributes = nil;
		self.actions = nil;
	}

	return self;
}

- (void)fetchAttributes {
	CFArrayRef attrs = NULL;
	AXUIElementCopyAttributeNames((__bridge AXUIElementRef)self.element, &attrs);

	int count = attrs != NULL ? (int)CFArrayGetCount(attrs) : 0;
	if (self.attributes) {
		[self.attributes removeAllObjects];
	}
	else {
		self.attributes = [[NSMutableArray alloc] initWithCapacity:count];
	}

	for (int i=0; i<count; ++i) {
		NSString *value = (__bridge NSString*)CFArrayGetValueAtIndex(attrs, i);
		[self.attributes addObject:[[AXAttribute alloc] initWithName:value]];
	}

	if (attrs)
		CFRelease(attrs);
}

- (void)fetchActions {
	CFArrayRef actions = NULL;
	AXUIElementCopyActionNames((__bridge AXUIElementRef)self.element, &actions);

	int count = actions != NULL ? (int)CFArrayGetCount(actions) : 0;
	if (self.actions) {
		[self.actions removeAllObjects];
	}
	else {
		self.actions = [[NSMutableArray alloc] initWithCapacity:count];
	}

	for (int i=0; i<count; ++i) {
		NSString *value = (__bridge NSString*)CFArrayGetValueAtIndex(actions, i);
		[self.actions addObject:[[AXAction alloc] initWithName:value]];
	}

	if (actions)
		CFRelease(actions);
}

- (NSArray *)getAttributes {
	if (self.attributes == nil || self.attributes.count < 1) {
		[self fetchAttributes];
	}
	return self.attributes;
}

- (NSArray *)getActions {
	if (self.actions == nil || self.actions.count < 1) {
		[self fetchActions];
	}
	return self.actions;
}

- (AXAttribute *)hasAttribute:(NSString *)name {
	if (self.attributes == nil || self.attributes.count < 1) {
		[self fetchAttributes];
	}

	for (AXAttribute *attr in self.attributes) {
		if ([attr.name isEqualToString:name]) {
			return attr;
		}
	}

	return nil;
}

- (AXAction *)hasAction:(NSString *)name {
	if (self.actions == nil || self.actions.count < 1) {
		[self fetchActions];
	}

	for (AXAction *action in self.actions) {
		if ([action.name isEqualToString:name]) {
			return action;
		}
	}

	return nil;
}

- (BOOL)performAction:(NSString *)name {
	AXError error = AXUIElementPerformAction(
		(__bridge AXUIElementRef)self.element, (__bridge CFStringRef)name);

	if (error != kAXErrorSuccess) {
		NSLog(@"Failed to perform action: %@ on element: %d", name, error);
		return NO;
	}

	return YES;
}

- (id)getParent {
	return [self getAXUIElementValueOfAttrName:NSAccessibilityParentAttribute];
}

- (NSString *)getRole {
	return [self getStrValueOfAttrName:NSAccessibilityRoleAttribute];
}

- (NSString *)getTitle {
	return [self getStrValueOfAttrName:NSAccessibilityTitleAttribute];
}

- (NSString *)getIdentifier {
	return [self getStrValueOfAttrName:NSAccessibilityIdentifierAttribute];
}

- (BOOL)isApplication {
	return [self hasAttribute:NSAccessibilityApplicationRole] != nil;
}

////////////////////////////////////////////////////////////////////////////////
//
// Attribute value getter functions
//
////////////////////////////////////////////////////////////////////////////////
- (id)getValueOfAttrName:(NSString *)name {
	CFTypeRef value = nil;

	if (AXUIElementCopyAttributeValue(
		(__bridge AXUIElementRef)self.element, (__bridge CFStringRef)name, &value
		) == kAXErrorSuccess) {
		return CFBridgingRelease(value);
	}

	return nil;
}

- (BOOL)getBoolValueOfAttrName:(NSString *)name {
	CFTypeRef value = nil;

	if (AXUIElementCopyAttributeValue(
		(__bridge AXUIElementRef)self.element, (__bridge CFStringRef)name, &value
		) == kAXErrorSuccess) {
		NSNumber *n = CFBridgingRelease(value);
		return [n intValue] != 0;
	}

	return NO;
}

- (NSString *)getStrValueOfAttrName:(NSString *)name {
	CFTypeRef value = nil;

	if (AXUIElementCopyAttributeValue(
		(__bridge AXUIElementRef)self.element, (__bridge CFStringRef)name, &value
		) == kAXErrorSuccess) {
		return CFBridgingRelease(value);
	}

	return nil;
}

- (id)getAXUIElementValueOfAttrName:(NSString *)name {
	CFTypeRef value = nil;

	if (AXUIElementCopyAttributeValue(
		(__bridge AXUIElementRef)self.element, (__bridge CFStringRef)name, &value
		) == kAXErrorSuccess) {
		return CFBridgingRelease(value);
	}

	return nil;
}

- (NSArray *)getArrayValueOfAttrName:(NSString *)name {
	CFIndex count = 0;
	if (AXUIElementGetAttributeValueCount(
		(__bridge AXUIElementRef)self.element, (__bridge CFStringRef)name, &count
		) == kAXErrorSuccess) {

		CFArrayRef values = nil;
		if (AXUIElementCopyAttributeValues(
			(__bridge AXUIElementRef)self.element, (__bridge CFStringRef)name, 0,
			count, &values) == kAXErrorSuccess) {
			return CFBridgingRelease(values);
		}
	}
	else {
		NSLog(@"Can't get array count for attribute: %@", name);
	}

	return nil;
}

- (CGPoint)getCGPointValueOfAttrName:(NSString *)name {
	CFTypeRef value = nil;
	CGPoint position = {-1, -1};

	if (AXUIElementCopyAttributeValue(
		(__bridge AXUIElementRef)self.element, (__bridge CFStringRef)name, &value
		) == kAXErrorSuccess) {
		AXValueGetValue(value, kAXValueCGPointType, (void*)&position);
		CFRelease(value);
	}

	return position;
}

- (CGSize)getCGSizeValueOfAttrName:(NSString *)name {
	CFTypeRef value = nil;
	CGSize size = {-1, -1};

	if (AXUIElementCopyAttributeValue(
		(__bridge AXUIElementRef)self.element, (__bridge CFStringRef)name, &value
		) == kAXErrorSuccess) {
		AXValueGetValue(value, kAXValueCGSizeType, (void*)&size);
		CFRelease(value);
	}

	return size;
}

- (CFRange)getCFRangeValueOfAttrName:(NSString *)name {
	CFTypeRef value = nil;
	CFRange range = {0, 0};

	if (AXUIElementCopyAttributeValue(
		(__bridge AXUIElementRef)self.element, (__bridge CFStringRef)name, &value
		) == kAXErrorSuccess) {
		AXValueGetValue(value, kAXValueCFRangeType, (void*)&range);
		CFRelease(value);
	}

	return range;
}

////////////////////////////////////////////////////////////////////////////////
//
// Attribute value setter functions
//
////////////////////////////////////////////////////////////////////////////////
- (BOOL)isAttributeSettable:(NSString *)name {
	Boolean isSettable = NO;
	AXUIElementIsAttributeSettable(
		(__bridge AXUIElementRef)self.element,
		(__bridge CFStringRef)name,
		&isSettable);
	return (BOOL)isSettable;
}

- (BOOL)setBoolValueForAttrName:(NSString *)name
                          value:(BOOL)value {
	return (AXUIElementSetAttributeValue(
		(__bridge AXUIElementRef)self.element,
		(__bridge CFStringRef)name,
		value ? kCFBooleanTrue : kCFBooleanFalse
		) == kAXErrorSuccess);
}

- (BOOL)setStrValueForAttrName:(NSString *)name
                         value:(NSString *)value {
	return (AXUIElementSetAttributeValue(
		(__bridge AXUIElementRef)self.element,
		(__bridge CFStringRef)name,
		(__bridge CFTypeRef)value
		) == kAXErrorSuccess);
}

- (BOOL)setArrayValueForAttrName:(NSString *)name
                           value:(NSArray *)array {
	return (AXUIElementSetAttributeValue(
		(__bridge AXUIElementRef)self.element,
		(__bridge CFStringRef)name,
		(__bridge CFTypeRef)array
		) == kAXErrorSuccess);
}

- (BOOL)setCGPointValueForAttrName:(NSString *)name
                             value:(CGPoint)point {
	CFTypeRef value = AXValueCreate(kAXValueCGPointType, (const void*)&point);
	BOOL ret = (AXUIElementSetAttributeValue(
	             (__bridge AXUIElementRef)self.element,
	             (__bridge CFStringRef)name,
	             value) == kAXErrorSuccess);
	CFRelease(value);
	return ret;
}

- (BOOL)setCGSizeValueForAttrName:(NSString *)name
                            value:(CGSize)size {
	CFTypeRef value = AXValueCreate(kAXValueCGSizeType, (const void*)&size);
	BOOL ret = (AXUIElementSetAttributeValue(
	             (__bridge AXUIElementRef)self.element,
	             (__bridge CFStringRef)name,
	             value) == kAXErrorSuccess);
	CFRelease(value);
	return ret;
}

- (BOOL)setCGRectValueForAttrName:(NSString *)name
                            value:(CGRect)rect {
	CFTypeRef value = AXValueCreate(kAXValueCGRectType, (const void*)&rect);
	BOOL ret = (AXUIElementSetAttributeValue(
	             (__bridge AXUIElementRef)self.element,
	             (__bridge CFStringRef)name,
	             value) == kAXErrorSuccess);
	CFRelease(value);
	return ret;
}

- (BOOL)setCFRangeValueForAttrName:(NSString *)name
                             value:(CFRange)range {
	CFTypeRef value = AXValueCreate(kAXValueCFRangeType, (const void*)&range);
	BOOL ret = (AXUIElementSetAttributeValue(
	             (__bridge AXUIElementRef)self.element,
	             (__bridge CFStringRef)name,
	             value) == kAXErrorSuccess);
	CFRelease(value);
	return ret;
}

- (BOOL)setNSRangeValueForAttrName:(NSString *)name
                             value:(NSRange)range {
	CFRange fRange;
	fRange.location = range.location;
	fRange.length = range.length;

	CFTypeRef value = AXValueCreate(kAXValueCFRangeType, (const void*)&fRange);
	BOOL ret = (AXUIElementSetAttributeValue(
	             (__bridge AXUIElementRef)self.element,
	             (__bridge CFStringRef)name,
	             value) == kAXErrorSuccess);
	CFRelease(value);
	return ret;
}

@end
