//
//  AXUIWindow.m
//
//  Created by chao on 7/10/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "AXUIWindow.h"
#import "AXAction.h"
#import "AXAttribute.h"

@interface AXUIWindow()

@end

@implementation AXUIWindow

- (instancetype)initWithElement:(id)element {

    if (self = [super initWithElement:element]) {
        self.title = nil;
        self.x = 0;
        self.y = 0;
        self.width = 0;
        self.height =0;
        self.identifier = nil;
    }

    return self;
}

- (BOOL)isFocused {
    return [self getBoolValueOfAttrName:NSAccessibilityFocusedAttribute];
}

- (BOOL)isMainWindow {
    return [self getBoolValueOfAttrName:NSAccessibilityMainAttribute];
}

- (BOOL)isMinimized {
    return [self getBoolValueOfAttrName:NSAccessibilityMinimizedAttribute];
}

- (BOOL)isModal {
    return [self getBoolValueOfAttrName:NSAccessibilityModalAttribute];
}

- (BOOL)isFullScreen {
    return [self getBoolValueOfAttrName:@"AXFullScreen"];
}

- (CGPoint)getPosition {
    return [self getCGPointValueOfAttrName:NSAccessibilityPositionAttribute]; 
}

- (CGSize)getSize {
    return [self getCGSizeValueOfAttrName:NSAccessibilitySizeAttribute];
}

- (CGRect)getFrame {
    CGPoint point = [self getCGPointValueOfAttrName:
                              NSAccessibilityPositionAttribute];
    CGSize size = [self getCGSizeValueOfAttrName:NSAccessibilitySizeAttribute];
    return CGRectMake(point.x, point.y, size.width, size.height);
}

- (BOOL)setPosition:(CGPoint)position {
    return [self setCGPointValueForAttrName:NSAccessibilityPositionAttribute
                                      value:position];
}

- (BOOL)setPositionWithX:(CGFloat)x y:(CGFloat)y {
    return [self setCGPointValueForAttrName:NSAccessibilityPositionAttribute
                                      value:CGPointMake(x, y)];
}

- (BOOL)setSize:(CGSize)size {
    return [self setCGSizeValueForAttrName:NSAccessibilitySizeAttribute
                                     value:size];
}

- (BOOL)setSizeWithWidth:(CGFloat)width height:(CGFloat)height {
    return [self setCGSizeValueForAttrName:NSAccessibilitySizeAttribute
                                     value:CGSizeMake(width, height)];
}

- (BOOL)setFrame:(CGRect)rect {
    if ([self setCGPointValueForAttrName:NSAccessibilityPositionAttribute
                                   value:rect.origin]) {
        return [self setCGSizeValueForAttrName:NSAccessibilitySizeAttribute
                                         value:rect.size];
    }

    return NO;
}

- (BOOL)setMainWindow {
    return [self setBoolValueForAttrName:NSAccessibilityMainAttribute
                                   value:YES];
}

- (BOOL)setFrameWithX:(CGFloat)x
                    y:(CGFloat)y
                width:(CGFloat)width
               height:(CGFloat)height {
    if ([self setCGPointValueForAttrName:NSAccessibilityPositionAttribute
                                   value:CGPointMake(x, y)]) {
        return [self setCGSizeValueForAttrName:NSAccessibilitySizeAttribute
                                         value:CGSizeMake(width, height)];
    }

    return NO;
}

////////////////////////////////////////////////////////////////////////////////
//
// Button related functions
//
////////////////////////////////////////////////////////////////////////////////
- (AXUIButton*)getButton:(NSString *)name {
    id ref = [self getAXUIElementValueOfAttrName:name];
    if (ref) {
        return [[AXUIButton alloc] initWithElement:ref];
    }

    return nil;
}

- (AXUIButton *)getCloseButton {
    return [self getButton:NSAccessibilityCloseButtonAttribute];
}

- (AXUIButton *)getDefaultButton {
    return [self getButton:NSAccessibilityDefaultButtonAttribute];
}

- (AXUIButton *)getCancelButton {
    return [self getButton:NSAccessibilityCancelButtonAttribute];
}

- (AXUIButton *)getMinimizeButton {
    return [self getButton:NSAccessibilityMinimizeButtonAttribute];
}

- (AXUIButton *)getToolbarButton {
    return [self getButton:NSAccessibilityToolbarButtonAttribute];
}

- (AXUIButton *)getZoomButton {
    return [self getButton:NSAccessibilityZoomButtonAttribute];
}

- (AXUIButton *)getFullScreenButton {
    return [self getButton:NSAccessibilityFullScreenButtonAttribute];
}

- (BOOL)enterFullScreen {
    return [self setBoolValueForAttrName:@"AXFullScreen" value:YES];
}

- (BOOL)exitFullScreen {
    return [self setBoolValueForAttrName:@"AXFullScreen" value:NO];
}

- (BOOL)restoreFromMinimized {
    return [self setBoolValueForAttrName:NSAccessibilityMinimizedAttribute
                                   value:NO];
}

@end
