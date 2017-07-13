//
//	WindowHotKey.m
//
//	Created by chao on 8/14/16.
//	Copyright © 2016 eschao. All rights reserved.
//

#import "WindowHotKey.h"
#import "HotKey_protected.h"
#import "../Utils/Constants.h"

@interface WindowHotKey()

@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSString *desc;
@property (nonatomic, strong, readwrite) NSString *defaultHotKey;

@end

@implementation WindowHotKey

- (instancetype)initWithName:(NSString *)name
                 description:(NSString *)description
               defaultHotKey:(NSString *)defaultHotKey
                     keyCode:(NSUInteger)keyCode
                      keyMod:(NSUInteger)keyMod
                      target:(id)target
                      action:(SEL)action {
	if (self = [super initWithKeyCode:keyCode
	                           keyMod:keyMod
	                           target:target
	                           action:action]) {
		self.name = name;
		self.desc = description;
		self.defaultHotKey = defaultHotKey;
	}

	return self;
}

- (instancetype)initWithName:(NSString *)name
                 description:(NSString *)description
               defaultHotKey:(NSString *)defaultHotKey
                      hotKey:(NSString *)hotKey
                      target:(id)target
                      action:(SEL)action {
	if (self = [super initWithHotKey:hotKey target:target action:action]) {
		self.name = name;
		self.desc = description;
		self.defaultHotKey = defaultHotKey;
	}

	return self;
}

- (instancetype)initWithName:(NSString *)name
                 description:(NSString *)description
               defaultHotKey:(NSString *)defaultHotKey
                      target:(id)target
                      action:(SEL)action {

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *myHotKeys = [userDefaults dictionaryForKey:MyWindowHotKeysKey];
	NSString *hotKey = nil;
	if (myHotKeys != nil) {
		NSDictionary *t = [myHotKeys objectForKey:name];
		if (t != nil) {
			hotKey = [t objectForKey:HotKeyKey];
		}
	}

	if (self = [super initWithHotKey:hotKey target:target action:action]) {
		self.name = name;
		self.desc = description;
		self.defaultHotKey = defaultHotKey;
	}

	return self;
}

- (NSString *)getName {
	return self.name;
}

- (BOOL)canRestoreWithDefaultHotKey {
	if (self.defaultHotKey == nil) {
		return NO;
	}

	CombinedKey cKey = {0, 0};
	if (![self parseHotKey:self.defaultHotKey combinedKey:&cKey]) {
		return NO;
	}

	return cKey.keyCode != self.keyCode || cKey.keyMod != self.keyMod;
}

/*
- (BOOL)registerWith:(NSString *)hotKey {
		NSUInteger oldKeyCode = self.keyCode;
		NSUInteger oldKeyMod = self.keyMod;

		BOOL ret = [super registerWith:hotKey];

		if (oldKeyCode != self.keyCode
				|| oldKeyMod != self.keyMod) {
				[PreferenceUitl saveWindowHotKey:self];
		}

		return ret;
}

- (BOOL)registerWith:(NSUInteger)keyCode
							keyMod:(NSUInteger)keyMod {
		NSUInteger oldKeyCode = self.keyCode;
		NSUInteger oldKeyMod = self.keyMod;

		BOOL ret = [super registerWith:keyCode keyMod:keyMod];

		if (oldKeyCode != self.keyCode
				|| oldKeyMod != self.keyMod) {
				[PreferenceUitl saveWindowHotKey:self];
		}

		return ret;
}

- (BOOL)enable:(NSString *)hotKey {
		if ([super enable:hotKey]) {
				[PreferenceUitl saveWindowHotKey:self];
				return YES;
		}

		return NO;
}

- (BOOL)disable {
		if ([super disable]) {
				[PreferenceUitl saveWindowHotKey:self];
				return YES;
		}

		return NO;
}
 */

@end
