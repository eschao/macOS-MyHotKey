//
//  WindowGridsHotKeyPrefItem.h
//
//  Created by chao on 7/24/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WindowHotKey;

@interface WindowGridsHotKeyPrefItem: NSObject

@property (nonatomic, strong) WindowHotKey  *hotKey;
@property (nonatomic, strong) NSImage       *icon;
@property (nonatomic, strong) NSString      *changedHotKey;


- (instancetype)initWith:(WindowHotKey *)hotKey
                    icon:(NSImage *)icon;

@end
