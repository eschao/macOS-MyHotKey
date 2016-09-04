//
//  WindowGridsHotKeyPrefItem.m
//
//  Created by chao on 7/24/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "WindowGridsHotKeyPrefItem.h"
#import "../../HotKey/WindowHotKey.h"

@interface WindowGridsHotKeyPrefItem()

@end

@implementation WindowGridsHotKeyPrefItem

- (instancetype)initWith:(WindowHotKey *)hotKey
                    icon:(NSImage *)icon {
    if (self = [super init]) {
        self.hotKey = hotKey;
        self.icon = icon;
        self.changedHotKey = nil;
    }

    return self;
}

@end
