//
//	HotKeyManager.m
//
//	Created by chao on 7/11/16.
//	Copyright © 2016 eschao. All rights reserved.
//

#import "HotKeyManager.h"
#import "HotKey.h"
#import "../Utils/Constants.h"

static HotKeyManager *_sharedManager = nil;
static dispatch_once_t _onceToken;

static OSStatus hotKeyHandler(EventHandlerCallRef handler,
	EventRef event, void* data) {
	EventHotKeyID hotKeyID;
	GetEventParameter(event, kEventParamDirectObject, typeEventHotKeyID, NULL,
		sizeof(hotKeyID), NULL, &hotKeyID);
	HotKeyManager *hotKeyMgr = (__bridge HotKeyManager *)data;
	NSNumber *key = [HotKey getID:(NSUInteger)hotKeyID.signature
	                       keyMod:hotKeyID.id];
	[hotKeyMgr dispatch:key];

	return noErr;
}

@interface HotKeyManager()

@property (nonatomic, strong) NSMutableDictionary		*hotKeyMap;

@end

@implementation HotKeyManager

+ (instancetype)sharedManager {
	dispatch_once(&_onceToken, ^{
		_sharedManager = [[HotKeyManager alloc] init];
		}
	);

	return _sharedManager;
}

- (instancetype)init {
	if (self = [super init]) {
		EventTypeSpec eventType;
		eventType.eventClass = kEventClassKeyboard;
		eventType.eventKind = kEventHotKeyPressed;
		InstallApplicationEventHandler(
			&hotKeyHandler,
			1,
			&eventType,
			(__bridge void*)self,
			NULL);

		self.hotKeyMap = [[NSMutableDictionary alloc] init];
	}

	return self;
}

/*
- (HotKey *)bind:(NSString *)name
					hotKey:(NSString *)hotKey
	 defaultHotKey:(NSString *)defaultHotKey
					target:(id)target
					action:(SEL)action {
		HotKey *hKey = [[HotKey alloc] initWithName:name
																		description:name
																	defaultHotKey:defaultHotKey
																				 hotKey:hotKey
																				 target:target
																				 action:action];
		if ([hKey register]) {
				[self.hotKeyMap setObject:hKey forKey:[hKey getID]];
				return hKey;
		}

		return nil;
}

- (HotKey *)bind:(NSString *)name
	 defaultHotKey:(NSString *)defaultHotKey
				 keyCode:(NSUInteger)keyCode
					keyMod:(NSUInteger)keyMod
					target:(id)target
					action:(SEL)action {
		HotKey *hotKey = [[HotKey alloc] initWithName:name
																			description:name
																		defaultHotKey:defaultHotKey
																					keyCode:keyCode
																					 keyMod:keyMod
																					 target:target
																					 action:action];
		if ([hotKey register]) {
				[self.hotKeyMap setObject:hotKey forKey:[hotKey getID]];
				return hotKey;
		}

		return nil;
}*/

- (BOOL)bind:(HotKey *)hotKey {
	if ([hotKey register]) {
		[self.hotKeyMap setObject:hotKey forKey:[hotKey getID]];
		return YES;
	}

	return NO;
}

- (BOOL)bind:(HotKey *)hotKey
   newHotKey:(NSString *)newHotKey {
	if ([hotKey registerWith:newHotKey]) {
		[self.hotKeyMap setObject:hotKey forKey:[hotKey getID]];
		return YES;
	}

	return NO;
}

- (BOOL)bind:(HotKey *)hotKey
  newKeyCode:(NSInteger)newKeyCode
   newKeyMod:(NSInteger)newKeyMod {
	if ([hotKey registerWith:newKeyCode keyMod:newKeyMod]) {
		[self.hotKeyMap setObject:hotKey forKey:[hotKey getID]];
		return YES;
	}

	return NO;
}

- (BOOL)unbind:(HotKey *)hotKey {
	if ([hotKey unregister]) {
		[self.hotKeyMap removeObjectForKey:[hotKey getID]];
		return YES;
	}

	return NO;
}

- (void)unbindAll {
	NSArray *allHotKeys = [self.hotKeyMap allValues];
	for (HotKey *hotKey in allHotKeys) {
		if (![hotKey unregister]) {
			NSLog(@"Unbind all: can't unregister hot key: %@", hotKey);
		}
	}

	[self.hotKeyMap removeAllObjects];
}

- (void)dispatch:(NSNumber *)hotKeyID {
	HotKey *hotKey = [self.hotKeyMap objectForKey:hotKeyID];
	if (hotKey) {
		[hotKey perform];
	} else {
		NSLog(@"Can not find hot key for ID: %@", hotKeyID);
	}
}

- (HotKey *)isRegistered:(NSUInteger)keyCode
                  keyMod:(NSUInteger)keyMod {
	NSNumber *keyID = [HotKey getID:keyCode keyMod:keyMod];
	return [self.hotKeyMap objectForKey:keyID];
}

- (BOOL)isSystemHotKey:(NSUInteger)keyCode
                keyMod:(NSUInteger)keyMod {
	CFArrayRef systemHotKeys = NULL;
	if (CopySymbolicHotKeys(&systemHotKeys)) {
		return YES;
	}

	CFIndex size = CFArrayGetCount(systemHotKeys);
	for (CFIndex i=0; i<size; ++i) {
		CFDictionaryRef hotKeyDict = (CFDictionaryRef)CFArrayGetValueAtIndex(
			systemHotKeys, i);
		if (!hotKeyDict ||
			(CFGetTypeID(hotKeyDict) != CFDictionaryGetTypeID())) {
			continue;
		}

		if (kCFBooleanTrue != (CFBooleanRef)CFDictionaryGetValue(
			hotKeyDict, kHISymbolicHotKeyEnabled)) {
			continue;
		}

		CFNumberRef keyCodeRef = (CFNumberRef)CFDictionaryGetValue(
			hotKeyDict, kHISymbolicHotKeyCode);
		NSInteger hotKeyCode = 0;
		CFNumberGetValue(keyCodeRef, kCFNumberLongType, &hotKeyCode);

		CFNumberRef keyModRef = (CFNumberRef)CFDictionaryGetValue(
			hotKeyDict, kHISymbolicHotKeyModifiers);
		NSInteger hotKeyMod = 0;
		CFNumberGetValue(keyModRef, kCFNumberLongType, &hotKeyMod);
		if (keyCode == hotKeyCode && keyMod == hotKeyMod) {
			return YES;
		}
	}

	return NO;
}

- (NSArray *)getAllHotKeys {
	return [self.hotKeyMap allValues];
}

@end
