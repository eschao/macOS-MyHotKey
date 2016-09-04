//
//  MyError.h
//
//  Created by chao on 8/21/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

FOUNDATION_EXPORT NSString * const MyDomain;

typedef enum {
    InValidUpdateDate = 0,
} MyErrorCode;

@interface MyError : NSObject

+ (NSError *)errorWithCode:(NSInteger)errorCode;
+ (NSError *)errorWithCode:(NSInteger)errorCode
                  userInfo:(NSDictionary *)userInfo;

@end
