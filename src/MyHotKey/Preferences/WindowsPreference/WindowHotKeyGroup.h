//
//  WindowHotKeyGroup.h
//
//  Created by chao on 7/16/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WindowHotKeyGroup: NSObject

@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSImage   *icon;

- (instancetype)initWith:(NSString *)title
                    icon:(NSImage *)icon;
- (instancetype)initWith:(NSString *)title
                    icon:(NSImage *)icon
             createBlock:(NSViewController *(^)(void))createBlock
         willAppearBlock:(void(^)(NSViewController *))willAppearBlock;


- (NSViewController *)getSettingViewController:(BOOL)forceCreate;

@end
