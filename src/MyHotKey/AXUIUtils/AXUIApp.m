//
//  AXApp.m
//
//  Created by chao on 7/10/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "AXUIApp.h"

@interface AXUIApp()

@property (nonatomic, strong, readwrite) NSString *name;
@property int pid;

@end

@implementation AXUIApp

- (instancetype)initWithPID:(int)pid {
    id appRef = CFBridgingRelease(AXUIElementCreateApplication(pid));

    if (appRef == nil) {
        NSLog(@"Can not create AXUIElement from pid: %d", pid);
        return nil;
    }

    if (self = [super initWithElement:appRef]) {
        self.pid = pid;
        self.name = [self getTitle];
    }

    return self;
}

- (int)getPID {
    return self.pid;
}

////////////////////////////////////////////////////////////////////////////////
//
// Get attribute values of application
//
////////////////////////////////////////////////////////////////////////////////
- (AXUIWindow *)getFocusedWindow {
    id ref = [self getAXUIElementValueOfAttrName:
                       NSAccessibilityFocusedWindowAttribute];
   
    if (ref) {
        return [[AXUIWindow alloc] initWithElement:ref];
    }

    return nil;
}

- (NSArray *)getAllWindows {
    NSArray *windows = [self getArrayValueOfAttrName:
                                 NSAccessibilityWindowsAttribute];

    if (windows != nil) {
        NSMutableArray *array = [[NSMutableArray alloc]
                                    initWithCapacity:windows.count];

        for (int i=0; i<windows.count; ++i) {
            [array addObject:[[AXUIWindow alloc] initWithElement:
                                          [windows objectAtIndex:i]]];
        }

        return array;
    }

    return nil;
}

- (AXMenuBar *)getMenuBar {
    id ref = [self getAXUIElementValueOfAttrName:
                                   NSAccessibilityMenuBarAttribute];
   
    if (ref) {
        return [[AXMenuBar alloc] initWithElement:ref];
    }

    return nil;
}

- (BOOL)isFrontmost {
    return [self getBoolValueOfAttrName:NSAccessibilityFrontmostAttribute];
}

- (BOOL)isHidden {
    return [self getBoolValueOfAttrName:NSAccessibilityHiddenAttribute];
}

- (AXUIWindow *)getMainWindow {
    id ref = [self getAXUIElementValueOfAttrName:
                                   NSAccessibilityMainWindowAttribute];
   
    if (ref) {
        return [[AXUIWindow alloc] initWithElement:ref];
    }

    return nil;
}

////////////////////////////////////////////////////////////////////////////////
//
// Class related functions
//
////////////////////////////////////////////////////////////////////////////////
+ (AXUIApp *)getFrontmostApp {
    NSWorkspace *sharedWS = [NSWorkspace sharedWorkspace];
    NSRunningApplication *runningApp = sharedWS.frontmostApplication;

    if (runningApp == nil) {
        return nil;
    }

    return [[AXUIApp alloc] initWithPID:runningApp.processIdentifier];
}

+ (NSArray *)getRunningApps {
    NSWorkspace *sharedWS = [NSWorkspace sharedWorkspace];
    NSArray *runningApps = sharedWS.runningApplications;

    if (runningApps == nil) {
        return nil;
    }

    NSMutableArray *apps = [[NSMutableArray alloc] init];
    for (NSRunningApplication *app in runningApps) {
        [apps addObject:[[AXUIApp alloc] initWithPID:app.processIdentifier]];
    }

    return apps;
}

@end
