//
//	AppDelegate.m
//	MyHotKey
//
//	Created by chao on 7/14/16.
//	Copyright © 2016 chao. All rights reserved.
//

#import "AppDelegate.h"
#import "HotKey/MyWindowHotKeys.h"
#import "HotKey/MyAppHotKeys.h"
#import "Preferences/UPreferencesWindowController.h"
#import "Preferences/Sync/CloudSyncHelper.h"
#import "Utils/Constants.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSStatusItem *statusBar;
@property (nonatomic, strong) UPreferencesWindowController *prefWindowCotnroller;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	[[MyWindowHotKeys sharedHotKeys] registerAll];
	[[MyAppHotKeys sharedHotKeys] registerAll];
	self.prefWindowCotnroller = [[UPreferencesWindowController alloc]
		initWithTitle:@"Preferences"];
	[self setupStatusMenu];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:AutoSyncKey]) {
		[[CloudSyncHelper sharedHelper] sync];
	}
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

- (void)setupStatusMenu {
	self.statusBar = [[NSStatusBar systemStatusBar]
		statusItemWithLength:NSVariableStatusItemLength];
	self.statusBar.image = [NSImage imageNamed:@"StatusIcon"];
	self.statusBar.highlightMode = YES;
	self.statusBar.menu = self.statusMenu;
	self.statusBar.toolTip = @"MyHotKey";
}
/*
- (void)initStatusBar {
		self.statusBar = [[NSStatusBar systemStatusBar]
												 statusItemWithLength:NSVariableStatusItemLength];
		self.statusBar.title = @"";
		self.statusBar.image = [NSImage imageNamed:@"StatusIcon"];
		self.statusBar.highlightMode = YES;

		NSMenu *menu = [[NSMenu alloc] init];
		[menu addItemWithTitle:@"Preferences"
										action:@selector(onPreferences:)
						 keyEquivalent:@""];
		[menu addItemWithTitle:@"About MyHotKey"
										action:@selector(onAbout)
						 keyEquivalent:@""];
		[menu addItem:[NSMenuItem separatorItem]];
		[menu addItemWithTitle:@"Quit MyHotKey"
										action:@selector(onQuit)
						 keyEquivalent:@""];
		self.statusBar.menu = menu;
}*/

- (IBAction)onPreferences:(id)sender {
	[NSApp activateIgnoringOtherApps:YES];
	[self.prefWindowCotnroller showWindow:sender];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender
										hasVisibleWindows:(BOOL)flag {
	[self.prefWindowCotnroller showWindow:self];

	NSArray *array = [[NSApplication sharedApplication] windows];
	for (NSWindow *w in array) {
		NSLog(@"Window: %@\n", w);
	}
	return YES;
}

@end
