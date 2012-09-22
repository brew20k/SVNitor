//
//  SettingsWindowController.m
//  SVNitor
//
//  Created by Kevin Kinnebrew on 9/19/12.
//  Copyright (c) 2012 Letteer's Home. All rights reserved.
//

#import "SettingsWindowController.h"
#import "Repository.h"

@implementation SettingsWindowController

@synthesize repositories;

- (void)windowWillLoad
{
  repositories = [[NSMutableArray alloc] init];
  [repositories addObject:[[Repository alloc] init]];
}

@end
