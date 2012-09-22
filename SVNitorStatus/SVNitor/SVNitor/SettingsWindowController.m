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

@synthesize repositories;

- (void)windowWillLoad
{
  NSArray *repo = [(AppDelegate *)[[NSApplication sharedApplication] delegate] loadDataForKey:@"repository"];
  
  if (repo)
  {
    repositories = [[NSMutableArray alloc] initWithArray:repo];
  } else
  {
    repositories = [[NSMutableArray alloc] init];
  }
}

-(IBAction)addItem:(id)sender
{
  [(AppDelegate *)[[NSApplication sharedApplication] delegate] saveData:repositories forKey:@"repository"];
}

-(IBAction)removeItem:(id)sender
{
  [(AppDelegate *)[[NSApplication sharedApplication] delegate] saveData:repositories forKey:@"repository"];
}

@end
