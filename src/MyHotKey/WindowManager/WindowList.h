//
//  WindowList.h
//
//  Created by chao on 7/9/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WindowList : NSObject

- (instancetype)init;
- (void)updateWindowList;
- (void)listActiveApp; 
- (void)moveFrontmostWindow;

@end
