//
//  UHotKeyTextField.m
//
//  Created by chao on 7/28/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Carbon/Carbon.h>
#import "UHotKeyTextField.h"
#import "UMessageDelegate.h"
#import "../HotKey/HotKeyMap.h"

@interface UHotKeyTextField()

@property void *oldHotKeyMode;
@property (strong) id<UMessageDelegate> messageDelegate;

@end

@implementation UHotKeyTextField

/*
- (instancetype)init {
    if (self = [super init]) {
        [self resetHotKey];
    }

    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self resetHotKey];
    }

    return self;
}

- (void)resetHotKey {
    self.hasCmdKey = NO;
    self.hasShiftKey = NO;
    self.hasOptKey = NO;
    self.hasCtrlKey = NO;
    self.charKey = nil;
}

- (void)keyUp:(NSEvent *)theEvent {
    NSLog(@"---- KeyUp ----");
    NSLog(@"TextFiled: %@", self);
}*/

- (void)setUMessageDelegate:(id<UMessageDelegate>)delegate {
    self.messageDelegate = delegate;
}

- (BOOL)becomeFirstResponder {
    NSLog(@"become first responder");
    self.oldHotKeyMode = PushSymbolicHotKeyMode(kHIHotKeyModeAllDisabled);
    return YES;
}

- (BOOL)performKeyEquivalent:(NSEvent *)theEvent {
    NSLog(@"---- performKeyEquivalent ----");
    if ([self currentEditor]) {
        NSLog(@"TextFiled: %@", self);
        [self parseKeyEvent:theEvent];
        return YES;
    }

    return NO;
}

- (void)parseKeyEvent:(NSEvent *)theEvent {
    NSLog(@"Pressed key: %@", theEvent);
    BOOL hasModifierKey = NO;
    NSUInteger keyMod = 0;
    NSMutableString *hotKey = [[NSMutableString alloc] init];
    
    if ([theEvent modifierFlags] & NSShiftKeyMask) {
        NSLog(@"Pressed SHIFT key!");
        [hotKey appendString:@"⇧"];
        keyMod += shiftKey;
    }

    if ([theEvent modifierFlags] & NSControlKeyMask) {
        NSLog(@"Pressed CTRL key!");
        [hotKey appendString:@"⌃"];
        hasModifierKey = YES;
        keyMod += controlKey;
    }

    if ([theEvent modifierFlags] & NSAlternateKeyMask) {
        NSLog(@"Pressed OPT key!");
        [hotKey appendString:@"⌥"];
        hasModifierKey = YES;
        keyMod += optionKey;
    }

    if ([theEvent modifierFlags] & NSCommandKeyMask) {
        NSLog(@"Pressed CMD key!"); 
        [hotKey appendString:@"⌘"];
        hasModifierKey = YES;
        keyMod += cmdKey;
    }

    NSString *key = [[HotKeyMap sharedMap].code2Key
                        objectForKey:@(theEvent.keyCode)];
    if (!hasModifierKey) {
        NSLog(@"At least need one key of control, command and option!");
    }
    else if (key == nil) {
        NSLog(@"Need a normal character key!");
    }
    else if (self.hotKeyFieldDelegate) {
        [hotKey appendString:key];
        [self.hotKeyFieldDelegate hotKeyDidChange:self
                                          keyCode:theEvent.keyCode
                                           keyMod:keyMod
                                           hotKey:hotKey];
    }
}

- (BOOL)textShouldBeginEditing:(NSText *)textObject {
    return NO;
}

- (BOOL)acceptsFirstResponder {
    NSLog(@"TextField acceptsFirstResponder");
    return YES;
}

- (void)textDidEndEditing:(NSNotification *)aNotification {
    NSLog(@"TextFiled didEndEditing!");
    if (self.oldHotKeyMode) {
        PopSymbolicHotKeyMode(self.oldHotKeyMode);
    }

    if (self.messageDelegate) {
        [self.messageDelegate clearMessage];
    }

    self.oldHotKeyMode = nil;
}

- (void)restoreHotKeyMode {
    if (self.oldHotKeyMode) {
        PopSymbolicHotKeyMode(self.oldHotKeyMode);
    }    

    self.oldHotKeyMode = nil;
}

@end
