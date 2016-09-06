//
//  MyWindowHotKeys.h
//
//  Created by chao on 7/19/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WindowHotKey;

@interface MyWindowHotKeys : NSObject

// 2 grids: horizontal, vertical
@property (nonatomic, strong) WindowHotKey  *v2Grids_left;
@property (nonatomic, strong) WindowHotKey  *v2Grids_right;
@property (nonatomic, strong) WindowHotKey  *h2Grids_top;
@property (nonatomic, strong) WindowHotKey  *h2Grids_bottom;

// 3 grids:
@property (nonatomic, strong) WindowHotKey  *v3Grids_left;
@property (nonatomic, strong) WindowHotKey  *v3Grids_middle;
@property (nonatomic, strong) WindowHotKey  *v3Grids_right;
@property (nonatomic, strong) WindowHotKey  *v3Grids_left_middle;
@property (nonatomic, strong) WindowHotKey  *v3Grids_middle_right;
@property (nonatomic, strong) WindowHotKey  *h3Grids_top;
@property (nonatomic, strong) WindowHotKey  *h3Grids_center;
@property (nonatomic, strong) WindowHotKey  *h3Grids_bottom;
@property (nonatomic, strong) WindowHotKey  *h3Grids_top_center;
@property (nonatomic, strong) WindowHotKey  *h3Grids_center_bottom;

// 4 grids: horizontal, vertical and even grids
@property (nonatomic, strong) WindowHotKey  *e4Grids_1;
@property (nonatomic, strong) WindowHotKey  *e4Grids_2;
@property (nonatomic, strong) WindowHotKey  *e4Grids_3;
@property (nonatomic, strong) WindowHotKey  *e4Grids_4;

@property (nonatomic, strong) WindowHotKey  *maximizeWindow;
@property (nonatomic, strong) WindowHotKey  *minimizeWindow;
@property (nonatomic, strong) WindowHotKey  *fullscreenWindow;
@property (nonatomic, strong) WindowHotKey  *centerWindow;

+ (MyWindowHotKeys *)sharedHotKeys;

- (void)registerAll;
- (void)reloadFromPrefs;
- (void)addReloadObserver:(id)observer
                 selector:(SEL)selector;
- (void)removeReloadObserver;

@end
