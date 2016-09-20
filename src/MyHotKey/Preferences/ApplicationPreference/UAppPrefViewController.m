//
//  UAppPrefViewcontroller.m
//
//  Created by chao on 8/11/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "UAppPrefViewController.h"
#import "UAddAppHotKeyDialog.h"
#import "../../HotKey/MyAppHotKeys.h"
#import "../../HotKey/AppHotKey.h"
#import "../../HotKey/HotKeyManager.h"
#import "../../AppUtils/AppInfo.h"
#import "../UHotKeyTextField.h"
#import "../../Utils/PreferenceUtil.h"

@interface UAppPrefViewController()

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextFieldCell *messageLabel;
@property (strong) NSMutableArray   *appsArray;
@property (strong) UAddAppHotKeyDialog *addDialog;
@property BOOL isChanged;

@end

@implementation UAppPrefViewController

- (instancetype)init {
    if (self = [super initWithNibName:@"ApplicationPref" bundle:nil]) {
        self.appsArray = [[NSMutableArray alloc] init];
        self.isChanged = NO;
        [[MyAppHotKeys sharedHotKeys]
            addReloadObserver:self
                     selector:@selector(notifiedHotKeysAreReloaded)];
    }

    return self;
}

- (void)awakeFromNib {
    /*
    NSRect frame = self.tableView.headerView.frame;
    frame.size.height = 24;
    self.tableView.headerView.frame = frame;
    */
}

- (void)viewDidLoad {
    [super viewDidLoad]; 
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    [[MyAppHotKeys sharedHotKeys] validateWithInstalledApps];
    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]
                  byExtendingSelection:NO];
}

- (void)viewDidDisappear {
    if (self.isChanged) {
        [PreferenceUtil saveMyAppHotKeys];
        self.isChanged = NO;
    }
}

- (void)notifiedHotKeysAreReloaded {
    [self.tableView reloadData];
}

- (IBAction)onAdd:(id)sender {
    if (self.addDialog == nil) {
        self.addDialog = [[UAddAppHotKeyDialog alloc] init];
    }

    [self.view.window beginSheet:[self.addDialog window]
               completionHandler: ^(NSModalResponse returnCode) {
            if (returnCode == NSModalResponseOK) {
                MyAppHotKeys *myAppHotKeys = [MyAppHotKeys sharedHotKeys];
                AppInfo *appInfo = self.addDialog.appsList.selectedItem
                                        .representedObject;
                if ([myAppHotKeys addAppHotKey:appInfo
                                     hotKeyStr:[self.addDialog.hotKeyTextField
                                                    stringValue]]) {
                    self.isChanged = YES;
                    [self.tableView reloadData];
                }
                else {
                    NSLog(@"Can not add hot key for application: %@",
                          appInfo.appName);
                }
            }

            self.addDialog = nil;
        }];
}

- (IBAction)onRemove:(id)sender {
    NSInteger selectedRow = self.tableView.selectedRow;
    if (selectedRow >= 0) {
        MyAppHotKeys *myAppHotKeys = [MyAppHotKeys sharedHotKeys];
        if ([myAppHotKeys removeAppHotKeyAtIndex:selectedRow]) {
            self.isChanged = YES;
            [self.tableView reloadData];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////
//
// NSTableViewDelegate functions
//
////////////////////////////////////////////////////////////////////////////////
- (BOOL)tableView:(NSTableView *)tableView
    shouldSelectT:(id)item {
    return NO;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    AppHotKey *item = [[MyAppHotKeys sharedHotKeys] appHotKeyAtIndex:row];
    NSTableCellView *cell = nil;
    NSString *columnID = tableColumn.identifier;

    if ([columnID isEqualToString:@"AppNameColID"]) {
        cell = [self.tableView makeViewWithIdentifier:@"AppNameCellID"
                                                owner:nil];
        NSString *iconPath = [item.appInfo getIconPath];

        if (iconPath != nil) {
            NSImage *icon = [[NSImage alloc] initWithContentsOfFile:iconPath];
            if (icon != nil) {
                [icon setSize:CGSizeMake(20, 20)];
                [[cell imageView] setImage:icon];
            }
        }

        [[cell textField] setStringValue:item.appInfo.appName];

        if (item.appInfo.isInstalled) {
            [cell textField].textColor = [NSColor blackColor];
        }
        else {
            [cell textField].textColor = [NSColor grayColor];            
        }
    }
    else if ([columnID isEqualToString:@"AppHotKeyColID"]) {
        cell = [self.tableView makeViewWithIdentifier:@"AppHotKeyCellID"
                                                owner:nil];
        UHotKeyTextField *field = (UHotKeyTextField *)[cell textField];
        field.hotKey = item;
        field.hotKeyFieldDelegate = self;
        [field setUMessageDelegate:self];
        NSString *s = [item hotKey2String];
        [field setStringValue:s];

        /*
        if (item.appInfo.isInstalled) {
            [cell textField].textColor = [NSColor blackColor];
            [[cell textField] setEnabled: YES];
        }
        else {
            [cell textField].textColor = [NSColor grayColor];
            [[cell textField] setEnabled: NO];
        }*/
    }
    return cell;
}

////////////////////////////////////////////////////////////////////////////////
//
// NSTableViewDataSource functions
//
////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [[MyAppHotKeys sharedHotKeys] getMyAppHotKeys].count;
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)rowIndex {
    return nil;
}

- (void)hotKeyDidChange:(UHotKeyTextField *)hotKeyField
                keyCode:(NSUInteger)keyCode
                 keyMod:(NSUInteger)keyMod
                 hotKey:(NSString *)hotKey {
    HotKeyManager *hotKeyMgr = [HotKeyManager sharedManager];
    AppHotKey *appHotKey = (AppHotKey *)hotKeyField.hotKey;

    if (![hotKeyMgr isSystemHotKey:keyCode keyMod:keyMod]
        && [hotKeyMgr isRegistered:keyCode keyMod:keyMod] == nil) {

        if (![hotKeyMgr unbind:hotKeyField.hotKey]) {
            [self.messageLabel setTitle:[NSString stringWithFormat:
                                @"Can't unregister hot key: %@",
                                appHotKey.appInfo.appName]];
        }
        else {
            self.isChanged = YES;
            [hotKeyField setStringValue:hotKey];
            if (![hotKeyMgr bind:hotKeyField.hotKey
                      newKeyCode:keyCode
                       newKeyMod:keyMod]) {
                [self.messageLabel setTitle:[NSString stringWithFormat:
                                @"Can't register shortcut '%@' with key: %@",
                                            appHotKey.appInfo.appName, hotKey]];
            }
        }
        
    }
    else {
        [self.messageLabel setTitle:[NSString stringWithFormat:
                                              @"Shortcut %@ is already used!",
                                              hotKey]];
    }
}

- (void)clearMessage {
    [self.messageLabel setTitle:@""];
}

@end
