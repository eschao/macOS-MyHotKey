//
//  WindowsPrefViewController.m
//
//  Created by chao on 7/16/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import "UWindowsPrefViewController.h"
#import "WindowHotKeyGroup.h"
#import "UWindowGridsHotKeyPrefViewController.h"

@interface UWindowsPrefViewController()

@property (strong) IBOutlet NSSplitView *vSplitView;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSView *rightPanel;
@property (weak) IBOutlet NSTextFieldCell *messageLabel;
@property (strong) UWindowGridsHotKeyPrefViewController * prefViewController;

@property (strong) NSMutableArray *dataArray;

@end

@implementation UWindowsPrefViewController

- (instancetype)init {
    if (self = [super initWithNibName:@"WindowsPref" bundle:nil]) {
        
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    self.prefViewController = [[UWindowGridsHotKeyPrefViewController alloc]
                                  initWith:self];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    [self.vSplitView setPosition:200 ofDividerAtIndex:0];
    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]
                byExtendingSelection:NO];
}

- (void)initData {
    self.dataArray = [[NSMutableArray alloc] init];
    [self.dataArray addObject:[[WindowHotKeyGroup alloc]
                            initWith:@"2 Window Grids"
                                icon:[NSImage imageNamed:@"2-windows"]
                         createBlock:^NSViewController*(void) {
                            return self.prefViewController;
                        }
                     willAppearBlock:^(NSViewController *vc) {
                            [self.prefViewController reloadData:kWindow2Grids];
                        }]];
    [self.dataArray addObject:[[WindowHotKeyGroup alloc]
                            initWith:@"3 Window Grids"
                                icon:[NSImage imageNamed:@"3-windows"]
                         createBlock:^NSViewController*(void) {
                            return self.prefViewController;
                        }
                     willAppearBlock:^(NSViewController *vc) {
                            [self.prefViewController reloadData:kWindow3Grids];
                        }]];
    [self.dataArray addObject:[[WindowHotKeyGroup alloc]
                                  initWith:@"4 Window Grids"
                                      icon:[NSImage imageNamed:@"4-windows"]
                               createBlock:^NSViewController*(void) {
                                return self.prefViewController;
                               }
                           willAppearBlock:^(NSViewController *vc) {
                            [self.prefViewController reloadData:kWindow4Grids];
                           }]];
    [self.dataArray addObject:[[WindowHotKeyGroup alloc]
                                  initWith:@"Windows"
                                      icon:nil
                               createBlock:^NSViewController*(void) {
                                return self.prefViewController;
                               }
                          willAppearBlock:^(NSViewController *vc) {
                            [self.prefViewController reloadData:kWindowHotKeys];
                          }]];
    /*
    [self.dataArray addObject:[[HotKeyType alloc]
                            initWithTitle:@"Window Size"
                                     icon:[NSImage imageNamed:@"WindowSize"]]];
    */
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

    WindowHotKeyGroup *item = [self.dataArray objectAtIndex:row];
    NSTableCellView *cell = [self.tableView 
                                makeViewWithIdentifier:@"MyCellID"
                                owner:nil];
    [[cell imageView] setImage:[item icon]];
    [[cell textField] setStringValue:[item title]];
    return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSIndexSet *selectedIndex = [self.tableView selectedRowIndexes];
    if (selectedIndex.count > 0) {
        WindowHotKeyGroup *item = [self.dataArray objectAtIndex:
                                           [selectedIndex firstIndex]];
        NSViewController *controller = [item getSettingViewController:NO];
        NSView *newSubview = [controller view];
        CGRect frame = self.rightPanel.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        [newSubview setFrame:frame];
        [self.rightPanel setSubviews:@[newSubview]];
        [newSubview setTranslatesAutoresizingMaskIntoConstraints:NO]; 

        // extend to fill parent space
        NSDictionary *views = @{@"hotKeysView" : newSubview};    
        [self.rightPanel addConstraints: [NSLayoutConstraint
                        constraintsWithVisualFormat:@"V:|-0-[hotKeysView]-0-|"
                                            options:0
                                            metrics:nil
                                              views:views]];
        [self.rightPanel addConstraints: [NSLayoutConstraint
                        constraintsWithVisualFormat:@"H:|-0-[hotKeysView]-0-|"
                                            options:0
                                            metrics:nil
                                              views:views]];
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
    return [self.dataArray count];
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
           row:(NSInteger)rowIndex {
    return nil;//[self.dataArray title];
}

- (void)setMessage:(NSString *)message {
    [self.messageLabel setTitle:message];
}

- (void)setMessageWith:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    [self.messageLabel setTitle:message];
}

- (void)clearMessage {
    [self.messageLabel setTitle:@""];
}

- (IBAction)onRestoreDefaults:(id)sender {
    if (self.prefViewController) {
        [self.prefViewController restoreDefaultHotKeys];
    }
}

@end
