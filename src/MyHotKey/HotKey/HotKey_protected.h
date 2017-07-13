//
//	HotKey_protected.h
//
//	Created by chao on 8/14/16.
//	Copyright © 2016 eschao. All rights reserved.
//

#import "HotKey.h"

typedef struct CombinedKey {
	NSUInteger keyCode;
	NSUInteger keyMod;
} CombinedKey;

@interface HotKey()

- (NSString *)getName;
- (BOOL)parseHotKey:(NSString *)hotKey
        combinedKey:(CombinedKey *)combinedKey;

@end
