//
//  AXAttribute.m
//
//  Created by chao on 7/10/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "AXAttribute.h"

@interface AXAttribute()

@property AXAttrValueType       type;

@end

@implementation AXAttribute

- (instancetype)initWithName:(NSString *)name {

    if (self = [super init]) {
        self.name = name;
        self.type = kAXAttrValueUnknownType;
    }

    return self;
}

- (instancetype)initWithCName:(CFStringRef)name {

    if (self = [super init]) {
        self.name = (__bridge_transfer NSString*)name;
        self.type = kAXAttrValueUnknownType;
    }

    return self;
}

- (id)getValue:(AXUIElementRef)element {
    CFTypeRef value = nil;
    if (AXUIElementCopyAttributeValue(element, (__bridge CFStringRef)self.name,
                                      &value) == kAXErrorSuccess) {
        id result = (__bridge_transfer id)value;
        self.type = (int)AXValueGetType(value);

        if (self.type > kAXAttrValueCFRangeType) {
            if ([result isKindOfClass:[NSString class]]) {
                self.type = kAXAttrValueNStringType;
            }
            else if ([result isKindOfClass:[NSValue class]]) {
                self.type = kAXAttrValueNValueType;
            }
        }

        return result;
    }

    return nil;
}

- (BOOL)isSettable:(AXUIElementRef)element {
    Boolean isSettable = NO;
    AXUIElementIsAttributeSettable(element, (__bridge CFStringRef)self.name,
                                   &isSettable);
    return (BOOL)isSettable;
}

- (BOOL)setValueWithNSString:(NSString *)value
                     element:(AXUIElementRef)element {
    
    if (self.type == kAXAttrValueUnknownType) {
        [self getValue:element];
    }
    
    if (self.type != kAXAttrValueNStringType) {
        NSLog(@"Attribute %@ is not a NSString value type, it is: %d", self.name,
              self.type);  
        return NO;
    }

    return (AXUIElementSetAttributeValue(element,
                                         (__bridge CFStringRef)self.name,
                                         (__bridge CFTypeRef)value)
            == kAXErrorSuccess);
}

- (BOOL)setValueWithNSValue:(NSValue *)value
                    element:(AXUIElementRef)element {
    if (self.type == kAXAttrValueUnknownType) {
        [self getValue:element];
    }

    if (self.type != kAXAttrValueNStringType) {
        NSLog(@"Attribute %@ is not a NSValue value type, it is: %d", self.name,
              self.type);  
        return NO;
    }

    return (AXUIElementSetAttributeValue(element,
                                         (__bridge CFStringRef)self.name,
                                         (__bridge CFTypeRef)value)
            == kAXErrorSuccess);
}

- (BOOL)setValueWithCGPoint:(CGPoint)point
                    element:(AXUIElementRef)element {
    if (self.type == kAXAttrValueUnknownType) {
        [self getValue:element];
    }

    if (self.type != kAXAttrValueCGPointType) {
        NSLog(@"Attribute %@ is not a CGPoint value type, it is: %d", self.name,
              self.type);  
        return NO;
    }

    CFTypeRef value = AXValueCreate(kAXValueCGPointType, (const void*)&point);
    BOOL ret = (AXUIElementSetAttributeValue(element,
                                             (__bridge CFStringRef)self.name,
                                             value)
                == kAXErrorSuccess);
    CFRelease(value);
    return ret;
}

- (BOOL)setValueWithCGSize:(CGSize)size
                   element:(AXUIElementRef)element {
    if (self.type == kAXAttrValueUnknownType) {
        [self getValue:element];
    }

    if (self.type != kAXAttrValueCGSizeType) {
        NSLog(@"Attribute %@ is not a CGSize value type, it is: %d", self.name,
              self.type);  
        return NO;
    }

    CFTypeRef value = AXValueCreate(kAXValueCGSizeType, (const void*)&size);
    BOOL ret = (AXUIElementSetAttributeValue(element,
                                             (__bridge CFStringRef)self.name,
                                             value)
                == kAXErrorSuccess);
    CFRelease(value);
    return ret;
}

- (BOOL)setValueWithCGRect:(CGRect)rect
                   element:(AXUIElementRef)element {
    if (self.type == kAXAttrValueUnknownType) {
        [self getValue:element];
    }

    if (self.type != kAXAttrValueCGRectType) {
        NSLog(@"Attribute %@ is not a CGRect value type, it is: %d", self.name,
              self.type);  
        return NO;
    }

    CFTypeRef value = AXValueCreate(kAXValueCGRectType, (const void*)&rect);
    BOOL ret = (AXUIElementSetAttributeValue(element,
                                             (__bridge CFStringRef)self.name,
                                             value)
                == kAXErrorSuccess);
    CFRelease(value);
    return ret;
}

- (BOOL)setValueWithCFRange:(CFRange)range
                    element:(AXUIElementRef)element {
    if (self.type == kAXAttrValueUnknownType) {
        [self getValue:element];
    }

    if (self.type != kAXAttrValueCFRangeType) {
        NSLog(@"Attribute %@ is not a CFRange value type, it is: %d", self.name,
              self.type);  
        return NO;
    }

    CFTypeRef value = AXValueCreate(kAXValueCFRangeType, (const void*)&range);
    BOOL ret = (AXUIElementSetAttributeValue(element,
                                             (__bridge CFStringRef)self.name,
                                             value)
                == kAXErrorSuccess);
    CFRelease(value);
    return ret;
}

- (BOOL)setValueWithNSRange:(NSRange)range
                    element:(AXUIElementRef)element {
    if (self.type == kAXAttrValueUnknownType) {
        [self getValue:element];
    }

    if (self.type != kAXAttrValueCFRangeType) {
        NSLog(@"Attribute %@ is not a CFRange value type, it is: %d", self.name,
              self.type);  
        return NO;
    }

    CFRange fRange;
    fRange.location = range.location;
    fRange.length = range.length;

    CFTypeRef value = AXValueCreate(kAXValueCFRangeType, (const void*)&fRange);
    BOOL ret = (AXUIElementSetAttributeValue(element,
                                             (__bridge CFStringRef)self.name,
                                             value)
                == kAXErrorSuccess);
    CFRelease(value);
    return ret;
}

+ (id)getValueWithName:(NSString *)name
               element:(AXUIElementRef)element {
    CFTypeRef value = nil;
    if (AXUIElementCopyAttributeValue(element, (__bridge CFStringRef)name,
                                      &value) == kAXErrorSuccess) {
        return (__bridge_transfer id)value;
    }

    return nil;
}

+ (BOOL)getBoolValueWithName:(NSString *)name
                     element:(AXUIElementRef)element {
    
    CFTypeRef value = nil;
    if (AXUIElementCopyAttributeValue(element, (__bridge CFStringRef)name,
                                      &value) == kAXErrorSuccess) {
        NSNumber *n = (__bridge_transfer NSNumber *)value;
        return [n intValue] != 0;
    }

    return NO;
}

+ (NSString *)getStrValueWithName:(NSString *)name
                          element:(AXUIElementRef)element {
    
    CFTypeRef value = nil;
    if (AXUIElementCopyAttributeValue(element, (__bridge CFStringRef)name,
                                      &value) == kAXErrorSuccess) {
        return (__bridge_transfer NSString *)value;
    }

    return nil;
}

+ (AXUIElementRef)getElementRefValueWithName:(NSString *)name
                                     element:(AXUIElementRef)element {
    
    CFTypeRef value = nil;
    if (AXUIElementCopyAttributeValue(element, (__bridge CFStringRef)name,
                                      &value) == kAXErrorSuccess) {
        return (AXUIElementRef)value;
    }

    return nil;
}

+ (NSArray *)getArrayValueWithName:(NSString *)name
                           element:(AXUIElementRef)element {
    CFTypeRef value = nil;
    if (AXUIElementCopyAttributeValue(element, (__bridge CFStringRef)name,
                                      &value) == kAXErrorSuccess) {
        return (__bridge_transfer NSArray *)value;
    }

    return nil;
}

@end
