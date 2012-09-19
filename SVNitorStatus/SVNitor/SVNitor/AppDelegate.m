//
//  AppDelegate.m
//  SVNitor
//
//  Created by Kevin Kinnebrew on 9/18/12.
//  Copyright (c) 2012 Letteer's Home. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  // Insert code here to initialize your application
  [statusMenu setAutoenablesItems:YES];
}

- (void)awakeFromNib
{
  statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  [statusItem setMenu:statusMenu];
  [statusItem setTitle:@"S"];
  [statusItem setHighlightMode:YES];
}

-(BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
  return YES;
}

-(IBAction)quitApplication:(id)sender
{
  [NSApp terminate: nil];
}

-(IBAction)openSettings:(id)sender
{
  settingsWindow = [[NSWindowController alloc] initWithWindowNibName:@"SettingsWindow"];
  [settingsWindow showWindow:nil];
}

@end
