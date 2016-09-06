//
//  UWindowGridsHotKeyPrefViewController.m
//
//  Created by chao on 7/23/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "UWindowGridsHotKeyPrefViewController.h"
#import "WindowGridsHotKeyPrefItem.h"
#import "../UHotKeyTextField.h"
#import "../UMessageDelegate.h"
#import "../../HotKey/WindowHotKey.h"
#import "../../HotKey/MyWindowHotKeys.h"
#import "../../HotKey/HotKeyManager.h"
#import "../../Utils/PreferenceUtil.h"

@interface UWindowGridsHotKeyPrefViewController()

@property (weak) IBOutlet NSTableView           *tableView;
@property (nonatomic, strong) NSMutableArray    *hotKeySettings;
@property (nonatomic, strong) NSMutableArray    *win2GridsHotKeys;
@property (nonatomic, strong) NSMutableArray    *win3GridsHotKeys;
@property (nonatomic, strong) NSMutableArray    *win4GridsHotKeys;
@property (nonatomic, strong) NSMutableArray    *windowHotKeys;
@property WindowGridsType                       type;
@property (strong) id<UMessageDelegate>         messageDelegate;
@property BOOL                                  isChanged;

@end

@implementation UWindowGridsHotKeyPrefViewController

- (instancetype)initWith:(id)delegate {
    if (self = [super initWithNibName:@"WindowGridsHotKeyPref" bundle:nil]) {
        self.hotKeySettings = [[NSMutableArray alloc] init];
        self.messageDelegate = delegate;
        self.isChanged = NO;
        [[MyWindowHotKeys sharedHotKeys]
            addReloadObserver:self
                     selector:@selector(notifiedHotKeysAreReloaded)];
    } 

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
}

- (void)viewDidDisappear {
    if (self.isChanged) {
        [PreferenceUtil saveMyWindowHotKeys];
        self.isChanged = NO;
    }
}

- (void)reloadData:(WindowGridsType)type {
    if (type == kWindow2Grids) {
        [self load2WindowGridsHotKeys];
    }
    else if (type == kWindow3Grids) {
        [self load3WindowGridsHotKeys];
    }
    else if (type == kWindow4Grids) {
        [self load4WindowGridsHotKeys];
    }
    else if (type == kWindowHotKeys) {
        [self loadWindowHotKeys];
    }
    else {
        NSLog(@"Can not support window grids type: %ld", type);
    }

    self.type = type;
    [self.tableView reloadData];
}

- (void)notifiedHotKeysAreReloaded {
    [self reloadData:self.type]; 
}

- (void)load2WindowGridsHotKeys {
    [self.hotKeySettings removeAllObjects];

    MyWindowHotKeys *myHotKeys = [MyWindowHotKeys sharedHotKeys];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.h2Grids_top
                                           icon:nil]];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.h2Grids_bottom
                                           icon:nil]];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.v2Grids_left
                                           icon:nil]];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.v2Grids_right
                                           icon:nil]];
}

- (void)load3WindowGridsHotKeys {
    [self.hotKeySettings removeAllObjects];

    MyWindowHotKeys *myHotKeys = [MyWindowHotKeys sharedHotKeys];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.h3Grids_top
                                           icon:nil]];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.h3Grids_center
                                           icon:nil]];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.h3Grids_bottom
                                           icon:nil]];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.h3Grids_top_center
                                           icon:nil]];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.h3Grids_center_bottom
                                           icon:nil]];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.v3Grids_left
                                           icon:nil]];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.v3Grids_middle
                                           icon:nil]];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.v3Grids_right
                                           icon:nil]];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.v3Grids_left_middle
                                           icon:nil]];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.v3Grids_middle_right
                                           icon:nil]];
}

- (void)load4WindowGridsHotKeys {
    [self.hotKeySettings removeAllObjects];

    MyWindowHotKeys *myHotKeys = [MyWindowHotKeys sharedHotKeys];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.e4Grids_1
                                           icon:nil]];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.e4Grids_2
                                           icon:nil]];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.e4Grids_3
                                           icon:nil]];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.e4Grids_4
                                           icon:nil]];
    
}

- (void)loadWindowHotKeys {
    [self.hotKeySettings removeAllObjects];

    MyWindowHotKeys *myHotKeys = [MyWindowHotKeys sharedHotKeys];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.maximizeWindow
                                           icon:nil]];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.minimizeWindow
                                           icon:nil]];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.fullscreenWindow
                                           icon:nil]];
    [self.hotKeySettings addObject:[[WindowGridsHotKeyPrefItem alloc]
                                       initWith:myHotKeys.centerWindow
                                           icon:nil]];
}

- (void)restoreDefaultHotKeys {
    HotKeyManager *hotKeyMgr = [HotKeyManager sharedManager];
    for (WindowGridsHotKeyPrefItem *row in self.hotKeySettings) {
        if ([row.hotKey canRestoreWithDefaultHotKey] &&
            [hotKeyMgr unbind:row.hotKey]) {
            if (![hotKeyMgr bind:row.hotKey
                       newHotKey:row.hotKey.defaultHotKey]) {
                NSLog(@"Can't bind hot key: %@", row.hotKey.desc); 
            }
        } 
    } 

    [self.tableView reloadData];
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
    WindowGridsHotKeyPrefItem *item = [self.hotKeySettings objectAtIndex:row];
    NSTableCellView *cell = nil;
    NSString *columnID = tableColumn.identifier;

    if ([columnID isEqualToString:@"HotKeyNameCol"]) {
        cell = [self.tableView makeViewWithIdentifier:@"HotKeyNameID"
                                                owner:nil];
        [[cell imageView] setImage:item.icon];
        [[cell textField] setStringValue:item.hotKey.desc];
    }
    else if ([columnID isEqualToString:@"HotKeyValueCol"]) {
        cell = [self.tableView makeViewWithIdentifier:@"HotKeyValueID"
                                                owner:nil];
        UHotKeyTextField *field = (UHotKeyTextField *)[cell textField];
        field.hotKey = item.hotKey;
        field.hotKeyFieldDelegate = self;
        [field setUMessageDelegate:self.messageDelegate];
        [field setStringValue:[item.hotKey hotKey2String]];
    }
    else {
        NSLog(@"Can not support column ID:%@ of table!", columnID);
    }

    return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSIndexSet *selectedIndex = [self.tableView selectedRowIndexes];
    if (selectedIndex.count > 1) {
        
    }
    else {
        
    }
}

////////////////////////////////////////////////////////////////////////////////
//
// NSTableViewDataSource functions
//
////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.hotKeySettings count];
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
           row:(NSInteger)rowIndex {
    return nil;//[self.dataArray title];
}

- (void)hotKeyDidChange:(UHotKeyTextField *)hotKeyField
                keyCode:(NSUInteger)keyCode
                 keyMod:(NSUInteger)keyMod
                 hotKey:(NSString *)hotKey {
    HotKeyManager *hotKeyMgr = [HotKeyManager sharedManager];
    WindowHotKey *winHotKey = (WindowHotKey *)hotKeyField.hotKey;

    if (![hotKeyMgr isSystemHotKey:keyCode keyMod:keyMod] &&
        [hotKeyMgr isRegistered:keyCode keyMod:keyMod] == nil) {

        if (![hotKeyMgr unbind:hotKeyField.hotKey]) {
            if (self.messageDelegate) {
                [self.messageDelegate setMessageWith:
                          @"Can't unregister hot key: %@",
                          winHotKey.desc]; 
            } 
            else {
                NSLog(@"Can't unregister hot key: %@", winHotKey.desc);
            }
        }
        else {
            self.isChanged = YES;
            [hotKeyField setStringValue:hotKey];

            if (![hotKeyMgr bind:hotKeyField.hotKey
                      newKeyCode:keyCode
                       newKeyMod:keyMod]) {
                if (self.messageDelegate) {
                    [self.messageDelegate setMessageWith:
                            @"Can't register shortcut '%@' with key: %@",
                            winHotKey.desc, hotKey]; 
                }
                else {
                    NSLog(@"Can't register shortcut '%@' for: %@!", hotKey,
                        winHotKey.desc);
                }
            }
        }
    }
    else if (self.messageDelegate) {
        [self.messageDelegate setMessageWith:@"Shortcut %@ is already used!",
                hotKey];
    }
    else {
        NSLog(@"Shortcut %@ is already used!", hotKey); 
    }
}

@end
