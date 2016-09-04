//
//  MyError.m
//
//  Created by chao on 8/21/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "MyError.h"

NSString * const MyDomain = @"com.eschao.myHotKey";

@implementation MyError

+ (NSError *)errorWithCode:(NSInteger)errorCode {
    return [[NSError alloc] initWithDomain:MyDomain
                                      code:errorCode
                                  userInfo:nil];
}

+ (NSError *)errorWithCode:(NSInteger)errorCode
                  userInfo:(NSDictionary *)userInfo {
    return [[NSError alloc] initWithDomain:MyDomain
                                      code:errorCode
                                  userInfo:userInfo];
   
}

@end
