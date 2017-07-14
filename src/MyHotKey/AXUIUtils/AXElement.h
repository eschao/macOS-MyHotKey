//
//  AXElement.h
//
//  Created by chao on 7/10/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AXAction.h"
#import "AXAttribute.h"

@interface AXElement : NSObject

@property (readonly) id element;

- (instancetype)initWithElement:(id)element;

- (AXAction *)hasAction:(NSString *)name;
- (AXAttribute *)hasAttribute:(NSString *)name;
- (NSArray *)getActions;
- (NSArray *)getAttributes;
- (BOOL)performAction:(NSString *)name;

- (id)getParent;
- (NSString *)getRole;
- (NSString *)getTitle;
- (NSString *)getIdentifier;
- (NSInteger)getChildrenCount;
- (BOOL)isApplication;

- (id)getValueOfAttrName:(NSString *)name;
- (BOOL)getBoolValueOfAttrName:(NSString *)name;
- (NSString *)getStrValueOfAttrName:(NSString *)name;
- (id)getAXUIElementValueOfAttrName:(NSString *)name;
- (NSArray *)getArrayValueOfAttrName:(NSString *)name;
- (CGPoint)getCGPointValueOfAttrName:(NSString *)name;
- (CGSize)getCGSizeValueOfAttrName:(NSString *)name;
- (CFRange)getCFRangeValueOfAttrName:(NSString *)name;

- (BOOL)isAttributeSettable:(NSString *)name;

- (BOOL)setBoolValueForAttrName:(NSString *)name
                          value:(BOOL)value;
- (BOOL)setStrValueForAttrName:(NSString *)name
                         value:(NSString *)value;
- (BOOL)setArrayValueForAttrName:(NSString *)name
                           value:(NSValue *)array;
- (BOOL)setCGPointValueForAttrName:(NSString *)name
                             value:(CGPoint)point;
- (BOOL)setCGSizeValueForAttrName:(NSString *)name
                            value:(CGSize)size;
- (BOOL)setCGRectValueForAttrName:(NSString *)name
                            value:(CGRect)rect;
- (BOOL)setCFRangeValueForAttrName:(NSString *)name
                             value:(CFRange)range;
- (BOOL)setNSRangeValueForAttrName:(NSString *)name
                             value:(NSRange)range;

@end
