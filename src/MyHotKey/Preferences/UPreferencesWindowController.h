//
//  UPreferencesWindowController.h
//
//  Created by chao on 7/16/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UPreferencesWindowController : NSWindowController<
                                          NSWindowDelegate,
                                          NSTabViewDelegate>

@property (strong) IBOutlet NSTabView *tabView;


- (instancetype)initWithTitle:(NSString *)title;
- (void)show;

@end
