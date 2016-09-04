//
//  AXAttribute.h
//
//  Created by chao on 7/10/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
    kAXAttrValueIllegalType     = kAXValueIllegalType,  // 0
    kAXAttrValueCGPointType     = kAXValueCGPointType,  // 1
    kAXAttrValueCGSizeType      = kAXValueCGSizeType,   // 2
    kAXAttrValueCGRectType      = kAXValueCGRectType,   // 3
    kAXAttrValueCFRangeType     = kAXValueCFRangeType,  // 4
    kAXAttrValueErrorType       = kAXValueAXErrorType,  // 5
    kAXAttrValueUnknownType     = -1,
    kAXAttrValueNStringType     = 1000,
    kAXAttrValueNValueType      = 1001
    
} AXAttrValueType;

@interface AXAttribute : NSObject

@property (nonatomic, strong) NSString          *name;

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithCName:(CFStringRef)name;

- (id)getValue:(AXUIElementRef)element;
- (BOOL)isSettable:(AXUIElementRef)element;

- (BOOL)setValueWithNSString:(NSString *)value
                     element:(AXUIElementRef)element;
- (BOOL)setValueWithNSValue:(NSValue *)value
                    element:(AXUIElementRef)element;
- (BOOL)setValueWithCGPoint:(CGPoint)point
                    element:(AXUIElementRef)element;
- (BOOL)setValueWithCGSize:(CGSize)size
                   element:(AXUIElementRef)element;
- (BOOL)setValueWithCGRect:(CGRect)rect
                   element:(AXUIElementRef)element;
- (BOOL)setValueWithCFRange:(CFRange)range
                  element:(AXUIElementRef)element;
- (BOOL)setValueWithNSRange:(NSRange)range
                    element:(AXUIElementRef)element;

+ (id)getValueWithName:(NSString *)name
               element:(AXUIElementRef)element;
+ (BOOL)getBoolValueWithName:(NSString *)name
                     element:(AXUIElementRef)element;
+ (NSString *)getStrValueWithName:(NSString *)name
                          element:(AXUIElementRef)element;
+ (AXUIElementRef)getElementRefValueWithName:(NSString *)name
                                     element:(AXUIElementRef)element;
+ (NSArray *)getArrayValueWithName:(NSString *)name
                           element:(AXUIElementRef)element;
@end
