//
//  UMessageDelegate.h
//
//  Created by chao on 8/7/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol UMessageDelegate

@optional
- (void)setMessage:(NSString *)msg;
- (void)setMessageWith:(NSString *)format, ...;

@required
- (void)clearMessage;

@end
