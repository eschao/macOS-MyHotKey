//
//  UAddAppHotKeyDialog.m
//
//  Created by chao on 8/13/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "UAddAppHotKeyDialog.h"
#import "../../HotKey/MyAppHotKeys.h"
#import "../../AppUtils/AppInfo.h"
#import "../UHotKeyTextField.h"
#import "../../HotKey/AppHotKey.h"
#import "../../HotKey/HotKeyManager.h"

@interface UAddAppHotKeyDialog()

@property (weak) IBOutlet NSTextField *messageLabel;
@property (weak) IBOutlet NSButton *addButton;
@property (nonatomic, weak) NSMenuItem *currentItem;

@end

@implementation UAddAppHotKeyDialog

- (instancetype)init {
    if (self = [super initWithWindowNibName:@"AddAppHotKeyDialog"]) {
        self.currentItem = nil;
    }

    return self;
}

- (void)windowDidLoad {
    [self initAppsList]; 
    self.hotKeyTextField.hotKeyFieldDelegate = self;
}

- (void)initAppsList {
    NSDictionary *apps = [[MyAppHotKeys sharedHotKeys]
                                   getInstalledAppsWithoutHotKey];

    for (AppInfo *info in apps.allValues) {
        [self.appsList addItemWithTitle:info.appName];
        NSString *iconPath = [info getIconPath];
        NSMenuItem *item = [self.appsList lastItem];
        item.representedObject = info;

        if (iconPath != nil) {
            NSImage *icon = [[NSImage alloc]
                                initWithContentsOfFile:iconPath];
            if (icon != nil) {
                [icon setSize:CGSizeMake(20, 20)];
                [item setImage:icon];
            }
        }
    }    

    self.currentItem = self.appsList.selectedItem;
}

- (IBAction)onCancel:(id)sender {
    [self.hotKeyTextField restoreHotKeyMode];
    [self.window.sheetParent endSheet:self.window
                           returnCode:NSModalResponseCancel];
}

- (IBAction)onAdd:(id)sender {
    [self.hotKeyTextField restoreHotKeyMode];
    [self.window.sheetParent endSheet:self.window
                           returnCode:NSModalResponseOK];
}
- (IBAction)onItemChanged:(id)sender {
    if (self.currentItem != self.appsList.selectedItem) {
        [self.hotKeyTextField setStringValue:@""];
        [self.messageLabel setStringValue:@""];
        [self.addButton setEnabled:NO];
    }
}

- (void)hotKeyDidChange:(UHotKeyTextField *)hotKeyField
                keyCode:(NSUInteger)keyCode
                 keyMod:(NSUInteger)keyMod
                 hotKey:(NSString *)hotKey {
    HotKeyManager *hotKeyMgr = [HotKeyManager sharedManager];
    if ([hotKeyMgr isSystemHotKey:keyCode keyMod:keyMod] ||
        [hotKeyMgr isRegistered:keyCode keyMod:keyMod] != nil) {
        [self.messageLabel setStringValue:
               [NSString stringWithFormat:@"The %@ is already used!", hotKey]];
    }
    else {
        [self.messageLabel setStringValue:@""];
        [self.hotKeyTextField setStringValue:hotKey];
        [self.addButton setEnabled:YES];
    }
}

@end
