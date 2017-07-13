//
//	WindowListData.h
//
//	Created by chao on 7/9/16.
//	Copyright © 2016 eschao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WindowListData : NSObject

@property (nonatomic, strong) NSMutableArray *dictArray;
@property (nonatomic) NSInteger              order;

- (instancetype)init;
- (void)clearAll;
- (void)debug;

@end
