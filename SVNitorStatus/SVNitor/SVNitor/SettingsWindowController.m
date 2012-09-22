//
//  SettingsWindowController.m
//  SVNitor
//
//  Created by Kevin Kinnebrew on 9/19/12.
//  Copyright (c) 2012 Letteer's Home. All rights reserved.
//

#import "SettingsWindowController.h"
#import "Repository.h"
#import "AppDelegate.h"

@implementation SettingsWindowController

@synthesize modalWindow;

- (IBAction)openWindow:(id)sender
{
  [NSApp beginSheet:modalWindow modalForWindow:[self window] modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction)closeWindow:(id)sender
{
  [NSApp endSheet:modalWindow];
  [modalWindow orderOut:modalWindow];
}

@end
