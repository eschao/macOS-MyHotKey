//
//  WindowHotKeyGroup.m
//
//  Created by chao on 7/16/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "WindowHotKeyGroup.h"

@interface WindowHotKeyGroup()

@property (nonatomic, strong) NSViewController  *viewController;
@property (nonatomic, strong) NSViewController  *(^viewCreateBlock)(void);
@property (nonatomic, strong) void (^viewWillAppearBlock)(NSViewController*);

@end

@implementation WindowHotKeyGroup 

- (instancetype)initWith:(NSString *)title
                    icon:(NSImage *)icon {
    if ((self = [super init])) {
        self.title = title;
        self.icon = icon;
        self.viewCreateBlock = nil;
        self.viewWillAppearBlock = nil;
        self.viewController = nil;
    }

    return self;
}

- (instancetype)initWith:(NSString *)title
                    icon:(NSImage *)icon
             createBlock:(NSViewController *(^)(void))createBlock
         willAppearBlock:(void(^)(NSViewController *))willAppearBlock {
    if (self = [super init]) {
        self.title = title;
        self.icon = icon;
        self.viewCreateBlock = createBlock;
        self.viewWillAppearBlock = willAppearBlock;
        self.viewController = nil;
    }

    return self;
}

- (NSViewController *)getSettingViewController:(BOOL)forceCreate {
    if (forceCreate || self.viewController == nil) {
        if (self.viewCreateBlock) {
            self.viewController = self.viewCreateBlock();
        }
        else {
            NSLog(@"No creation callback for view controller!");
        }
    }

    if (self.viewWillAppearBlock) {
        self.viewWillAppearBlock(self.viewController);
    }
    return self.viewController;
}

@end
