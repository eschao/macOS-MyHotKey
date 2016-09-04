//
//  MyWindowHotKeys.m
//
//  Created by chao on 7/19/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "MyWindowHotKeys.h"
#import "WindowHotKey.h"
#import "HotKeyManager.h"
#import "../Utils/Constants.h"
#import "../Utils/ScreenUtils.h"
#import "../Utils/PreferenceUtil.h"
#import "../AXUIUtils/AXUIApp.h"
#import "../AXUIUtils/AXUIWindow.h"

static MyWindowHotKeys    *_sharedHotKeys = nil;    
static dispatch_once_t  _onceToken;

@implementation MyWindowHotKeys

+ (instancetype)sharedHotKeys {
    dispatch_once(&_onceToken, ^{
            _sharedHotKeys = [[MyWindowHotKeys alloc] init];
        }
        );

    return _sharedHotKeys;
}

- (instancetype)init {
    if (self = [super init]) {
        NSDictionary *hotKeys = [[NSUserDefaults standardUserDefaults]
                                  objectForKey:MyWindowHotKeysKey];
        if (hotKeys == nil || hotKeys.count < 1) {
            [PreferenceUtil registerDefaultHotKeys];
        }
        
        [self defaultHotKeys];
    }

    return self;
} 

- (void)registerAll {
    HotKeyManager *manager = [HotKeyManager sharedManager];

    // register hot keys for 2 Grids
    [manager bind:self.v2Grids_left];
    [manager bind:self.v2Grids_right];
    [manager bind:self.h2Grids_top];
    [manager bind:self.h2Grids_bottom];

    // register hot keys for 3 Grids
    [manager bind:self.h3Grids_top];
    [manager bind:self.h3Grids_center];
    [manager bind:self.h3Grids_bottom];
    [manager bind:self.h3Grids_top_center];
    [manager bind:self.h3Grids_center_bottom];
    [manager bind:self.v3Grids_left];
    [manager bind:self.v3Grids_middle];
    [manager bind:self.v3Grids_right];
    [manager bind:self.v3Grids_left_middle];
    [manager bind:self.v3Grids_middle_right];

    // register hot keys for 4 Grids
    [manager bind:self.e4Grids_1];
    [manager bind:self.e4Grids_2];
    [manager bind:self.e4Grids_3];
    [manager bind:self.e4Grids_4];

    // window behavior
    [manager bind:self.maximizeWindow];
    [manager bind:self.minimizeWindow];
    [manager bind:self.fullscreenWindow];
    [manager bind:self.centerWindow];
}

- (void)defaultHotKeys {
    // 2 grids hotkey
    self.v2Grids_left = [[WindowHotKey alloc]
                            initWithName:v2GridsLeftName
                             description:v2GridsLeftDesc
                           defaultHotKey:v2GridsLeftHKey
                                  target:self
                                  action:@selector(performV2GridsLeft)];
    self.v2Grids_right = [[WindowHotKey alloc]
                             initWithName:v2GridsRightName
                              description:v2GridsRightDesc
                            defaultHotKey:v2GridsRightHKey
                                   target:self
                                   action:@selector(performV2GridsRight)];
    self.h2Grids_top = [[WindowHotKey alloc]
                           initWithName:h2GridsTopName
                            description:h2GridsTopDesc
                          defaultHotKey:h2GridsTopHKey
                                 target:self
                                 action:@selector(performH2GridsTop)];
    self.h2Grids_bottom = [[WindowHotKey alloc]
                              initWithName:h2GridsBottomName
                               description:h2GridsBottomDesc
                             defaultHotKey:h2GridsBottomHKey
                                    target:self
                                    action:@selector(performH2GridsBottom)];

    // 3 grids hotkey
    self.h3Grids_top = [[WindowHotKey alloc]
                           initWithName:h3GridsTopName
                            description:h3GridsTopDesc
                          defaultHotKey:h3GridsTopHKey
                                 target:self
                                 action:@selector(performH3GridsTop)];
    self.h3Grids_bottom = [[WindowHotKey alloc]
                              initWithName:h3GridsBottomName
                               description:h3GridsBottomDesc
                             defaultHotKey:h3GridsBottomHKey
                                    target:self
                                    action:@selector(performH3GridsBottom)];
    self.h3Grids_center = [[WindowHotKey alloc]
                              initWithName:h3GridsCenterName
                               description:h3GridsCenterDesc
                             defaultHotKey:h3GridsCenterHKey
                                    target:self
                                    action:@selector(performH3GridsCenter)];
    self.h3Grids_top_center = [[WindowHotKey alloc]
                              initWithName:h3GridsTopCenterName
                               description:h3GridsTopCenterDesc
                             defaultHotKey:h3GridsTopCenterHKey
                                    target:self
                                    action:@selector(performH3GridsTopCenter)];
    self.h3Grids_center_bottom = [[WindowHotKey alloc]
                          initWithName:h3GridsCenterBottomName
                           description:h3GridsCenterBottomDesc
                         defaultHotKey:h3GridsCenterBottomHKey
                                target:self
                                action:@selector(performH3GridsCenterBottom)];
    self.v3Grids_left = [[WindowHotKey alloc]
                            initWithName:v3GridsLeftName
                             description:v3GridsLeftDesc
                           defaultHotKey:v3GridsLeftHKey
                                  target:self
                                  action:@selector(performV3GridsLeft)];
    self.v3Grids_middle = [[WindowHotKey alloc]
                              initWithName:v3GridsMiddleName
                               description:v3GridsMiddleDesc
                             defaultHotKey:v3GridsMiddleHKey
                                    target:self
                                    action:@selector(performV3GridsMiddle)];
    self.v3Grids_right = [[WindowHotKey alloc]
                             initWithName:v3GridsRightName
                              description:v3GridsRightDesc
                            defaultHotKey:v3GridsRightHKey
                                   target:self
                                   action:@selector(performV3GridsRight)];
    self.v3Grids_left_middle = [[WindowHotKey alloc]
                             initWithName:v3GridsLeftMiddleName
                              description:v3GridsLeftMiddleDesc
                            defaultHotKey:v3GridsLeftMiddleHKey
                                   target:self
                                   action:@selector(performV3GridsLeftMiddle)];
    self.v3Grids_middle_right = [[WindowHotKey alloc]
                             initWithName:v3GridsMiddleRightName
                              description:v3GridsMiddleRightDesc
                            defaultHotKey:v3GridsMiddleRightHKey
                                   target:self
                                   action:@selector(performV3GridsMiddleRight)];

    // 4 Grids
    self.e4Grids_1 = [[WindowHotKey alloc]
                         initWithName:e4Grids_1_Name
                          description:e4Grids_1_Desc
                        defaultHotKey:e4Grids_1_HKey
                               target:self
                               action:@selector(performE4Grids1)];
    self.e4Grids_2 = [[WindowHotKey alloc]
                         initWithName:e4Grids_2_Name
                          description:e4Grids_2_Desc
                        defaultHotKey:e4Grids_2_HKey
                               target:self
                               action:@selector(performE4Grids2)];
    self.e4Grids_3 = [[WindowHotKey alloc]
                         initWithName:e4Grids_3_Name
                          description:e4Grids_3_Desc
                        defaultHotKey:e4Grids_3_HKey
                               target:self
                               action:@selector(performE4Grids3)];
    self.e4Grids_4 = [[WindowHotKey alloc]
                         initWithName:e4Grids_4_Name
                          description:e4Grids_4_Desc
                        defaultHotKey:e4Grids_4_HKey
                               target:self
                               action:@selector(performE4Grids4)];

    // window behavior
    self.maximizeWindow = [[WindowHotKey alloc]
                              initWithName:maximizeWinName
                               description:maximizeWinDesc
                             defaultHotKey:maximizeWinHKey
                                    target:self
                                    action:@selector(performMaximizeWindow)];
    self.minimizeWindow = [[WindowHotKey alloc]
                              initWithName:minimizeWinName
                               description:minimizeWinDesc
                             defaultHotKey:minimizeWinHKey
                                    target:self
                                    action:@selector(performMinimizeWindow)];
    self.fullscreenWindow = [[WindowHotKey alloc]
                                initWithName:fullscreenWinName
                                 description:fullscreenWinDesc
                               defaultHotKey:fullscreenWinHKey
                                      target:self
                                      action:@selector(performFullscreenWindow)];
    self.centerWindow = [[WindowHotKey alloc]
                            initWithName:centerWinName
                             description:centerWinDesc
                           defaultHotKey:centerWinHKey
                                  target:self
                                  action:@selector(performCenterWindow)];
}

- (BOOL)transformFocusedWindow:(CGRect (^)(CGRect rect))transform {
    CGRect screenRect = [ScreenUtils getVisibleScreenRect];
    AXUIApp *frontmostApp = [AXUIApp getFrontmostApp];
    AXUIWindow *focusedWindow = [frontmostApp getFocusedWindow];

    if (focusedWindow) {
        [focusedWindow setFrame:transform(screenRect)];
        return YES;
    }

    return NO;
}

////////////////////////////////////////////////////////////////////////////////
//
// 2 Grids related perform functions
//
////////////////////////////////////////////////////////////////////////////////
- (void)performV2GridsLeft {
    NSLog(@"Perform action: %@\n", v2GridsLeftName);
    if (![self transformFocusedWindow:^CGRect(CGRect rect) {
                rect.size.width /= 2;
                return rect;
            }]) {
        NSLog(@"[Perform action: %@] Can not get focused window!\n",
              v2GridsLeftName);
    }
}

- (void)performV2GridsRight {
    NSLog(@"Perform action: %@\n", v2GridsRightName);
    if (![self transformFocusedWindow:^CGRect(CGRect rect) {
                rect.size.width /= 2;
                rect.origin.x += rect.size.width;
                return rect;
            }]) {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              v2GridsRightName);
    }
}

- (void)performH2GridsTop {
    NSLog(@"Perform action: %@", h2GridsTopName);    
    if (![self transformFocusedWindow:^CGRect(CGRect rect) {
                rect.size.height /= 2;
                return rect;
            }]) {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              h2GridsTopName);
    }
}

- (void)performH2GridsBottom {
    NSLog(@"Perform action: %@", h2GridsBottomName);
    if (![self transformFocusedWindow:^(CGRect rect) {
                rect.size.height /= 2;
                rect.origin.y += rect.size.height;
                return rect;
         }]) {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              h2GridsBottomName);
    }
}

////////////////////////////////////////////////////////////////////////////////
//
// 3 Grids related perform functions
//
////////////////////////////////////////////////////////////////////////////////
- (void)performV3GridsLeft {
    NSLog(@"Perform action: %@", v3GridsLeftName);
    if (![self transformFocusedWindow:^CGRect(CGRect rect) {
                rect.size.width /= 3;
                return rect;
            }]) {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              v3GridsLeftName);
    }
}

- (void)performV3GridsMiddle {
    NSLog(@"Perform action: %@", v3GridsMiddleName);
    if (![self transformFocusedWindow:^CGRect(CGRect rect) {
                rect.size.width /= 3;
                rect.origin.x += rect.size.width;
                return rect;
            }]) {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              v3GridsMiddleName);
    }
}

- (void)performV3GridsRight {
    NSLog(@"Perform action: %@", v3GridsRightName);
    if (![self transformFocusedWindow:^CGRect(CGRect rect) {
                CGFloat w = rect.size.width / 3;
                rect.origin.x += rect.size.width - w;
                rect.size.width = w;
                return rect;
            }]) {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              v3GridsRightName);
    }
}

- (void)performV3GridsLeftMiddle {
    NSLog(@"Perform action: %@", v3GridsLeftMiddleName);
    if (![self transformFocusedWindow:^CGRect(CGRect rect) {
                CGFloat w = rect.size.width / 3.0f;
                rect.size.width -= w;
                return rect;
            }]) {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              v3GridsLeftMiddleName);
    }
}

- (void)performV3GridsMiddleRight {
    NSLog(@"Perform action: %@", v3GridsMiddleRightName);
    if (![self transformFocusedWindow:^CGRect(CGRect rect) {
                CGFloat w = rect.size.width / 3.0f;
                rect.origin.x += w;
                rect.size.width -= w;
                return rect;
            }]) {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              v3GridsMiddleRightName);
    }
}

- (void)performH3GridsTop {
    NSLog(@"Perform action: %@", h3GridsTopName);
    if (![self transformFocusedWindow:^CGRect(CGRect rect) {
                rect.size.height /= 3.0f;
                return rect;
            }]) {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              h3GridsTopName);
    }
}

- (void)performH3GridsCenter {
    NSLog(@"Perform action: %@", h3GridsCenterName);
    if (![self transformFocusedWindow:^CGRect(CGRect rect) {
                CGFloat h = rect.size.height / 3.0f;
                rect.origin.y += h;
                rect.size.height = h;
                return rect;
            }]) {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              h3GridsCenterName);
    }
}

- (void)performH3GridsBottom {
    NSLog(@"Perform action: %@", h3GridsBottomName);
    if (![self transformFocusedWindow:^CGRect(CGRect rect) {
                CGFloat h = rect.size.height / 3.0f;
                rect.origin.y += rect.size.height - h;
                rect.size.height = h;
                return rect;
            }]) {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              h3GridsBottomName);
    }
}

- (void)performH3GridsTopCenter {
    NSLog(@"Perform action: %@", h3GridsTopCenterName);
    if (![self transformFocusedWindow:^CGRect(CGRect rect) {
                CGFloat h = rect.size.height / 3.0f;
                rect.size.height -= h;
                return rect;
            }]) {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              h3GridsTopCenterName);
    }
}

- (void)performH3GridsCenterBottom {
    NSLog(@"Perform action: %@", h3GridsCenterBottomName);
    if (![self transformFocusedWindow:^CGRect(CGRect rect) {
                CGFloat h = rect.size.height / 3.0f;
                rect.origin.y += h;
                rect.size.height -= h;
                return rect;
            }]) {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              h3GridsCenterBottomName);
    }
}

////////////////////////////////////////////////////////////////////////////////
//
// 4 Grids related perform functions
//
//  +---+---+
//  | 1 | 3 |
//  +---+---+
//  | 2 | 4 |
//  +---+---+
////////////////////////////////////////////////////////////////////////////////
- (void)performE4Grids1 {
    NSLog(@"Perform action: %@", e4Grids_1_Name);
    if (![self transformFocusedWindow:^CGRect(CGRect rect) {
                rect.size.width /= 2.0f;
                rect.size.height /= 2.0f;
                return rect;
            }]) {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
                e4Grids_1_Name);
    }
}

- (void)performE4Grids2 {
    NSLog(@"Perform action: %@\n", e4Grids_2_Name);
    if (![self transformFocusedWindow:^CGRect(CGRect rect) {
                rect.size.width /= 2.0f;
                CGFloat h = rect.size.height / 2.0f;
                rect.origin.y += h;
                rect.size.height -=h;
                return rect;
            }]) {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              e4Grids_2_Name);
    }
}

- (void)performE4Grids3 {
    NSLog(@"Perform action: %@\n", e4Grids_3_Name);
    if (![self transformFocusedWindow:^CGRect(CGRect rect) {
                rect.size.height /= 2.0f;
                CGFloat w = rect.size.width / 2.0f;
                rect.origin.x += w;
                rect.size.width -= w;
                return rect;
            }]) {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              e4Grids_3_Name);
    }
}

- (void)performE4Grids4 {
    NSLog(@"Perform action: %@\n", e4Grids_4_Name);
    if (![self transformFocusedWindow:^CGRect(CGRect rect) {
                CGFloat w = rect.size.width / 2.0f;
                CGFloat h = rect.size.height / 2.0f;
                rect.origin.x += w;
                rect.origin.y += h;
                rect.size.width -= w;
                rect.size.height -= h;
                return rect;
            }]) {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              e4Grids_4_Name);
    }
}

////////////////////////////////////////////////////////////////////////////////
//
// Perform functions for Window behavior
//
////////////////////////////////////////////////////////////////////////////////
- (void)performMaximizeWindow {
    NSLog(@"Perform action: %@\n", maximizeWinName);
    if (![self transformFocusedWindow:^CGRect(CGRect rect) {
                return rect;
            }]) {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              maximizeWinName);
    }
}

- (void)performMinimizeWindow {
    NSLog(@"Perform action: %@\n", minimizeWinName);
    AXUIApp *frontmostApp = [AXUIApp getFrontmostApp];
    AXUIWindow *focusedWindow = [frontmostApp getFocusedWindow];

    if (focusedWindow) {
        AXUIButton *button = [focusedWindow getMinimizeButton];  
        if (button) {
            [button click];
        }
        else {
            NSLog(@"[Perform action: %@] Can not get minimize button!\n",
                  minimizeWinName);
        }
    }
    else {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              minimizeWinName);
    }
}

- (void)performFullscreenWindow {
    NSLog(@"Perform action: %@\n", fullscreenWinName);
    AXUIApp *frontmostApp = [AXUIApp getFrontmostApp];
    AXUIWindow *focusedWindow = [frontmostApp getFocusedWindow];

    if (focusedWindow) {
        if ([focusedWindow isFullScreen]) {
            [focusedWindow exitFullScreen];
        }
        else {
            [focusedWindow enterFullScreen];
        }
    }
    else {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              fullscreenWinName);
    }
}

- (void)performCenterWindow {
    NSLog(@"Perform action: %@", centerWinName);
    AXUIApp *frontmostApp = [AXUIApp getFrontmostApp];
    AXUIWindow *focusedWindow = [frontmostApp getFocusedWindow];
    CGRect screenRect = [ScreenUtils getVisibleScreenRect];

    if (focusedWindow) {
        CGRect winFrame = [focusedWindow getFrame];
        CGFloat wOffset = screenRect.size.width - winFrame.size.width;
        CGFloat wHeight = screenRect.size.height - winFrame.size.height;
        winFrame.origin.x = screenRect.origin.x + wOffset/2;
        winFrame.origin.y = screenRect.origin.y + wHeight/2;
        [focusedWindow setFrame:winFrame];
    }
    else {
        NSLog(@"[Peform action: %@] Can not get focused window!\n",
              centerWinName);
    }
}

@end
