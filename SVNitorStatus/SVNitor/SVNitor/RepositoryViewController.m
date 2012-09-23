//
//  RepositoryViewController.m
//  SVNitor
//
//  Created by Kevin Kinnebrew on 9/22/12.
//  Copyright (c) 2012 Letteer's Home. All rights reserved.
//

#import "RepositoryViewController.h"
#import "AppDelegate.h"
#import "Repository.h"

@implementation RepositoryViewController

@synthesize repositories;
@synthesize table;
@synthesize repoWindow;
@synthesize modalWindow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self loadRepositoriesForTable];
  }
  
  return self;
}

- (void)loadRepositoriesForTable
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

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  NSLog(@"count %i, %i", (int)[repositories count], (int)[tableView numberOfRows]);
  return [repositories count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  if ([[tableColumn identifier] isEqualToString:@"name"]) {
    return [[repositories objectAtIndex:row] name];
  } else {
    return [[repositories objectAtIndex:row] repositoryPath];
  }
}

- (IBAction)addItem:(id)sender
{
  [repositories addObject:[[Repository alloc] init]];
  NSIndexSet *index = [[NSIndexSet alloc] initWithIndex:([repositories count] - 1)];
  [table selectRowIndexes:index byExtendingSelection:NO];
  [table editColumn:0 row:([repositories count] - 1) withEvent:nil select:YES];
  [(AppDelegate *)[[NSApplication sharedApplication] delegate] saveData:repositories forKey:@"repository"];
  [table reloadData];
}

- (IBAction)removeItem:(id)sender
{
  if ([table selectedRow] < 0 || [table selectedRow] >= [repositories count])
    return;
  [repositories removeObjectAtIndex:[table selectedRow]];
  [(AppDelegate *)[[NSApplication sharedApplication] delegate] saveData:repositories forKey:@"repository"];
  [table reloadData];
}

- (IBAction)openWindow:(id)sender
{
  [NSApp beginSheet:modalWindow modalForWindow:repoWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction)closeWindow:(id)sender
{
  [NSApp endSheet:modalWindow];
  [modalWindow orderOut:modalWindow];
}

@end
