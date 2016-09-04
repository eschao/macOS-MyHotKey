//
//  AXAction.h
//
//  Created by chao on 7/10/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AXAction : NSObject

@property (nonatomic, strong) NSString  *name;

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithCName:(CFStringRef)name;
- (NSString *)description:(AXUIElementRef)element;
- (void)perform:(AXUIElementRef)element;

@end
