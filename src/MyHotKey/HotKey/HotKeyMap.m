//
//	HotKeyMap.m
//
//	Created by chao on 7/25/16.
//	Copyright © 2016 eschao. All rights reserved.
//

#import <Carbon/Carbon.h>
#import "HotKeyMap.h"

static HotKeyMap *_sharedMap = nil;
static dispatch_once_t _onceToken;

@interface HotKeyMap()

@property (nonatomic, strong, readwrite) NSDictionary  *code2Key;
@property (nonatomic, strong, readwrite) NSDictionary  *key2Code;
@property (nonatomic, strong, readwrite) NSDictionary  *mod2Code;

@end

@implementation HotKeyMap

+ (instancetype)sharedMap {
	dispatch_once(&_onceToken, ^{
		_sharedMap = [[HotKeyMap alloc] init];
	});

	return _sharedMap;
}

- (instancetype)init {
	if (self = [super init]) {
		[self initMap];
	}

	return self;
}

- (void)initMap {
	self.key2Code = @ {
		@"a" : @(kVK_ANSI_A),
		@"b" : @(kVK_ANSI_B),
		@"c" : @(kVK_ANSI_C),
		@"d" : @(kVK_ANSI_D),
		@"e" : @(kVK_ANSI_E),
		@"f" : @(kVK_ANSI_F),
		@"g" : @(kVK_ANSI_G),
		@"h" : @(kVK_ANSI_H),
		@"i" : @(kVK_ANSI_I),
		@"j" : @(kVK_ANSI_J),
		@"k" : @(kVK_ANSI_K),
		@"l" : @(kVK_ANSI_L),
		@"m" : @(kVK_ANSI_M),
		@"n" : @(kVK_ANSI_N),
		@"o" : @(kVK_ANSI_O),
		@"p" : @(kVK_ANSI_P),
		@"q" : @(kVK_ANSI_Q),
		@"u" : @(kVK_ANSI_U),
		@"r" : @(kVK_ANSI_R),
		@"s" : @(kVK_ANSI_S),
		@"t" : @(kVK_ANSI_T),
		@"u" : @(kVK_ANSI_U),
		@"v" : @(kVK_ANSI_V),
		@"w" : @(kVK_ANSI_W),
		@"x" : @(kVK_ANSI_X),
		@"y" : @(kVK_ANSI_Y),
		@"z" : @(kVK_ANSI_Z),

		@"0" : @(kVK_ANSI_0),
		@"1" : @(kVK_ANSI_1),
		@"2" : @(kVK_ANSI_2),
		@"3" : @(kVK_ANSI_3),
		@"4" : @(kVK_ANSI_4),
		@"5" : @(kVK_ANSI_5),
		@"6" : @(kVK_ANSI_6),
		@"7" : @(kVK_ANSI_7),
		@"8" : @(kVK_ANSI_8),
		@"9" : @(kVK_ANSI_9),

		@"," : @(kVK_ANSI_Comma),
		@"." : @(kVK_ANSI_Period),
		@"/" : @(kVK_ANSI_Slash),
		@";" : @(kVK_ANSI_Semicolon),
		@"'" : @(kVK_ANSI_Quote),
		@"[" : @(kVK_ANSI_LeftBracket),
		@"]" : @(kVK_ANSI_RightBracket),
		@"\\" : @(kVK_ANSI_Backslash),
		@"enter" : @(kVK_Return),
		@"↩" : @(kVK_Return),

		@"f1" : @(kVK_F1),
		@"f2" : @(kVK_F2),
		@"f3" : @(kVK_F3),
		@"f4" : @(kVK_F4),
		@"f5" : @(kVK_F5),
		@"f6" : @(kVK_F6),
		@"f7" : @(kVK_F7),
		@"f8" : @(kVK_F8),
		@"f9" : @(kVK_F9),
		@"f10" : @(kVK_F10),
		@"f11" : @(kVK_F11),
		@"f12" : @(kVK_F12),
		@"f13" : @(kVK_F13),
		@"f14" : @(kVK_F14),
		@"f15" : @(kVK_F15),

		@"esc" : @(kVK_Escape),
		@"⎋" : @(kVK_Escape),
		@"space" : @(kVK_Space),
		@"⎵" : @(kVK_Space),
		@"tab" : @(kVK_Tab),
		@"⇥" : @(kVK_Tab),
		@"delete" : @(kVK_Delete),
		@"⌫" : @(kVK_Delete),
		@"backspace" : @(kVK_Delete),
		@"capslock" : @(kVK_CapsLock),
		@"⇪" : @(kVK_CapsLock),

		@"home" : @(kVK_Home),
		@"end" : @(kVK_End),
		@"pageup" : @(kVK_PageUp),
		@"pagedown" : @(kVK_PageDown),
		@"leftarrow" : @(kVK_LeftArrow),
		@"rightarrow" : @(kVK_RightArrow),
		@"downarrow" : @(kVK_DownArrow),
		@"uparrow" : @(kVK_UpArrow),
		@"←" : @(kVK_LeftArrow),
		@"→" : @(kVK_RightArrow),
		@"↓" : @(kVK_DownArrow),
		@"↑" : @(kVK_UpArrow)
	};

	self.code2Key = @{
		@(kVK_ANSI_A) : @"A",
		@(kVK_ANSI_B) : @"B",
		@(kVK_ANSI_C) : @"C",
		@(kVK_ANSI_D) : @"D",
		@(kVK_ANSI_E) : @"E",
		@(kVK_ANSI_F) : @"F",
		@(kVK_ANSI_G) : @"G",
		@(kVK_ANSI_H) : @"H",
		@(kVK_ANSI_I) : @"I",
		@(kVK_ANSI_J) : @"J",
		@(kVK_ANSI_K) : @"K",
		@(kVK_ANSI_L) : @"L",
		@(kVK_ANSI_M) : @"M",
		@(kVK_ANSI_N) : @"N",
		@(kVK_ANSI_O) : @"O",
		@(kVK_ANSI_P) : @"P",
		@(kVK_ANSI_Q) : @"Q",
		@(kVK_ANSI_U) : @"U",
		@(kVK_ANSI_R) : @"R",
		@(kVK_ANSI_S) : @"S",
		@(kVK_ANSI_T) : @"T",
		@(kVK_ANSI_U) : @"U",
		@(kVK_ANSI_V) : @"V",
		@(kVK_ANSI_W) : @"W",
		@(kVK_ANSI_X) : @"X",
		@(kVK_ANSI_Y) : @"Y",
		@(kVK_ANSI_Z) : @"Z",

		@(kVK_ANSI_0) : @"0",
		@(kVK_ANSI_1) : @"1",
		@(kVK_ANSI_2) : @"2",
		@(kVK_ANSI_3) : @"3",
		@(kVK_ANSI_4) : @"4",
		@(kVK_ANSI_5) : @"5",
		@(kVK_ANSI_6) : @"6",
		@(kVK_ANSI_7) : @"7",
		@(kVK_ANSI_8) : @"8",
		@(kVK_ANSI_9) : @"9",

		@(kVK_ANSI_Comma) : @",",
		@(kVK_ANSI_Period) : @".",
		@(kVK_ANSI_Slash) : @"/",
		@(kVK_ANSI_Semicolon) : @";",
		@(kVK_ANSI_Quote) : @"'",
		@(kVK_ANSI_LeftBracket) : @"[",
		@(kVK_ANSI_RightBracket) : @"]",
		@(kVK_ANSI_Backslash) : @"\\",
		@(kVK_Return) : @"↩",

		@(kVK_F1) : @"F1",
		@(kVK_F2) : @"F2",
		@(kVK_F3) : @"F3",
		@(kVK_F4) : @"F4",
		@(kVK_F5) : @"F5",
		@(kVK_F6) : @"F6",
		@(kVK_F7) : @"F7",
		@(kVK_F8) : @"F8",
		@(kVK_F9) : @"F9",
		@(kVK_F10) : @"F10",
		@(kVK_F11) : @"F11",
		@(kVK_F12) : @"F12",
		@(kVK_F13) : @"F13",
		@(kVK_F14) : @"F14",
		@(kVK_F15) : @"F15",

		@(kVK_Escape) : @"⎋",
		@(kVK_Space) : @"⎵",
		@(kVK_Tab) : @"⇥",
		@(kVK_Delete) : @"⌫",
		@(kVK_CapsLock) : @"⇪",

		@(kVK_Home) : @"Home",
		@(kVK_End) : @"End",
		@(kVK_PageUp) : @"PageUp",
		@(kVK_PageDown) : @"PageDown",
		@(kVK_LeftArrow) : @"←",
		@(kVK_RightArrow) : @"→",
		@(kVK_DownArrow) : @"↓",
		@(kVK_UpArrow) : @"↑"
	};

	self.mod2Code = @ {
		@"apple" : @(cmdKey),
		@"cmd" : @(cmdKey),
		@"command" : @(cmdKey),
		@"⌘" : @(cmdKey),

		@"ctrl" : @(controlKey),
		@"control" : @(controlKey),
		@"⌃" : @(controlKey),

		@"opt" : @(optionKey),
		@"alt" : @(optionKey),
		@"option" : @(optionKey),
		@"⌥" : @(optionKey),

		@"shift" : @(shiftKey),
		@"⇧" : @(shiftKey),
	};
}

@end
