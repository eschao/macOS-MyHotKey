//
//  UPreferencesWindowController.m
//
//  Created by chao on 7/16/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Carbon/Carbon.h>
#import "UPreferencesWindowController.h"
#import "WindowsPreference/UWindowsPrefViewController.h"
#import "ApplicationPreference/UAppPrefViewController.h"
#import "Sync/USyncPrefViewController.h"
#import "../Utils/PreferenceUtil.h"

@interface UPreferencesWindowController()

@property (strong) UWindowsPrefViewController   *winPrefController;
@property (strong) UAppPrefViewController       *appPrefController;
@property (strong) USyncPrefViewController      *syncPrefController;
@property void *oldHotKeyMode;

@end

@implementation UPreferencesWindowController

- (instancetype)initWithTitle:(NSString *)title {
    
    /*
    NSString *nibPath = [[NSBundle
                             bundleForClass:PreferencesWindowController.class]
                            pathForResource:@"Preferences"
                                     ofType:@"nib"];*/
    if ((self = [super initWithWindowNibName:@"Preferences"])) {
    }

    return self;
}

- (void)windowDidLoad {
    if (self.tabView) {
        [self initTabView]; 
        NSLog(@"Tab view is inited");
    }

    [self.window setTitle:@"Preferences"];
    //[self.window setReleasedWhenClosed:NO];
}

- (void)windowWillClose:(NSNotification *)notification {
    [PreferenceUtil cloudSync];
}

- (void)initTabView {
    NSTabViewItem *syncItem = [[NSTabViewItem alloc]
                                     initWithIdentifier:@"SyncTabViewItem"];
    [syncItem setLabel:@"Sync"];
    [self.tabView addTabViewItem:syncItem];
    self.syncPrefController = [[USyncPrefViewController alloc]
                               initWithWindow:[self window]];
    [syncItem setView:[self.syncPrefController view]];

    self.winPrefController = [[UWindowsPrefViewController alloc] init];
    NSTabViewItem *windowTabItem = [self.tabView tabViewItemAtIndex:0];
    [windowTabItem setView:[self.winPrefController view]];

    self.appPrefController = [[UAppPrefViewController alloc] init];
    NSTabViewItem *appTabItem = [self.tabView tabViewItemAtIndex:1];
    [appTabItem setView:[self.appPrefController view]];

    /*
    [self.tabView setTranslatesAutoresizingMaskIntoConstraints:NO]; 
    NSDictionary *views = @{@"windowView" : windowItem.view};    
    [self.tabView addConstraints: [NSLayoutConstraint
                        constraintsWithVisualFormat:@"V:|-10-[windowView]-10-|"
                                            options:0
                                            metrics:nil
                                              views:views]];
    [self.tabView addConstraints: [NSLayoutConstraint
                        constraintsWithVisualFormat:@"H:|-10-[windowView]-10-|"
                                            options:0
                                            metrics:nil
                                              views:views]];
    */
}

////////////////////////////////////////////////////////////////////////////////
//
// NSTabViewDelegate related functions
//
////////////////////////////////////////////////////////////////////////////////
// Informs the delegate that the number of tab view items in tabview has changed
- (void)tabViewDidChangeNumberOfTabViewItems:(NSTabView *)tabView {
    
}

// Invoked just before tabViewItem in tabView is selected
- (BOOL)tabView:(NSTabView *)tabView
shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem {
    return YES;
}

// Informs the delegate that tabView is about to select tabViewItem
- (void)tabView:(NSTabView *)tabView
willSelectTabViewItem:(NSTabViewItem *)tabViewItem {
    
}

// Informs the delegate that tabView has selected tabViewItem
- (void)tabView:(NSTabView *)tabView
didSelecteTabViewItem:(NSTabViewItem *)tabViewItem {
    
}

- (void)windowDidBecomeKey:(NSNotification *)notification {
    //self.oldHotKeyMode = PushSymbolicHotKeyMode(kHIHotKeyModeAllDisabled);
}

- (void)windowDidResignKey:(NSNotification *)notification {
    //PopSymbolicHotKeyMode(self.oldHotKeyMode);
}

- (void)show {
    [[self window] makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}
@end
