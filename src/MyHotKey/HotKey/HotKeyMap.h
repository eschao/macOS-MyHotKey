//
//  HotKeyMap.h
//
//  Created by chao on 7/25/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HotKeyMap : NSObject

@property (nonatomic, strong, readonly) NSDictionary  *code2Key;
@property (nonatomic, strong, readonly) NSDictionary  *key2Code;
@property (nonatomic, strong, readonly) NSDictionary  *mod2Code;

+ (instancetype)sharedMap;

@end
