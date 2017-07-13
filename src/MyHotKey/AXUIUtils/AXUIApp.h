//
//	AXApp.h
//
//	Created by chao on 7/10/16.
//	Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AXElement.h"
#import "AXUIWindow.h"
#import "AXMenuBar.h"

@interface AXUIApp : AXElement

@property (nonatomic, strong, readonly) NSString *name;

- (instancetype)initWithPID:(int)pid;

- (int)getPID;
- (AXMenuBar *)getMenuBar;
- (NSArray *)getAllWindows;
- (AXUIWindow *)getFocusedWindow;
- (AXUIWindow *)getMainWindow;
- (BOOL)isHidden;
- (BOOL)isFrontmost;

+ (AXUIApp *)getFrontmostApp;
+ (NSArray *)getRunningApps;

@end
