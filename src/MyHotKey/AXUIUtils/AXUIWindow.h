//
//	AXUIWindow.h
//
//	Created by chao on 7/10/16.
//	Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AXElement.h"
#import "AXUIButton.h"

@interface AXUIWindow : AXElement

@property (nonatomic, strong) NSString  *title;
@property (nonatomic) NSInteger         x;
@property (nonatomic) NSInteger         y;
@property (nonatomic) NSInteger         width;
@property (nonatomic) NSInteger         height;
@property (nonatomic, strong) NSString  *identifier;
@property CGWindowID                    windowID;

- (instancetype)initWithElement:(id)element;

- (BOOL)isFocused;
- (BOOL)isMainWindow;
- (BOOL)isMinimized;
- (BOOL)isModal;
- (BOOL)isFullScreen;

- (CGPoint)getPosition;
- (CGSize)getSize;
- (CGRect)getFrame;
- (NSString *)getIdentifier;

- (BOOL)setMainWindow;
- (BOOL)setPosition:(CGPoint)position;
- (BOOL)setPositionWithX:(CGFloat)x y:(CGFloat)y;
- (BOOL)setSize:(CGSize)size;
- (BOOL)setSizeWithWidth:(CGFloat)width height:(CGFloat)height;
- (BOOL)setFrame:(CGRect)rect;
- (BOOL)setFrameWithX:(CGFloat)x
                    y:(CGFloat)y
                width:(CGFloat)width
               height:(CGFloat)height;

- (AXUIButton *)getCloseButton;
- (AXUIButton *)getDefaultButton;
- (AXUIButton *)getCancelButton;
- (AXUIButton *)getMinimizeButton;
- (AXUIButton *)getToolbarButton;
- (AXUIButton *)getZoomButton;
- (AXUIButton *)getFullScreenButton;

- (BOOL)enterFullScreen;
- (BOOL)exitFullScreen;
- (BOOL)restoreFromMinimized;

@end
