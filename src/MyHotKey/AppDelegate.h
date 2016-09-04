//
//  AppDelegate.h
//  MyHotKey
//
//  Created by chao on 7/14/16.
//  Copyright © 2016 chao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>

@property (weak) IBOutlet NSMenu *statusMenu;

@end

