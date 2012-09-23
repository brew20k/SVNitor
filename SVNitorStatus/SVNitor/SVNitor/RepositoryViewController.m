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
#import "LogMessage.h"

@implementation RepositoryViewController

@synthesize repositories;
@synthesize table;
@synthesize repoWindow;
@synthesize modalWindow;
@synthesize repoNameField;
@synthesize repoPathField;

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

- (IBAction)removeItem:(id)sender
{
  // TODO: should show confirmation dialog
  
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

- (IBAction)saveRepo:(id)sender
{
  NSString *repoName = [repoNameField stringValue];
  NSString *repoPath = [repoPathField stringValue];
  
  Repository *repo = [[Repository alloc] init];
  [repo setName:repoName];
  [repo setRepositoryPath:repoPath];
  
  // TODO: should check if repository is already added
  
  [repositories addObject:repo];
  [(AppDelegate *)[[NSApplication sharedApplication] delegate] saveData:repositories forKey:@"repository"];
  [table reloadData];
  
  [NSApp endSheet:modalWindow];
  [modalWindow orderOut:modalWindow];
  
}

- (IBAction)closeWindow:(id)sender
{
  [NSApp endSheet:modalWindow];
  [modalWindow orderOut:modalWindow];
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  return NO;
}

- (IBAction)browseToFile:(id)sender
{
  NSOpenPanel* openDlg = [NSOpenPanel openPanel];
  
  [openDlg setCanChooseFiles:NO];
  
  [openDlg setCanChooseDirectories:YES];

  if ([openDlg runModal]) {

    NSURL* url = [openDlg directoryURL];
    
    [repoPathField setStringValue:[url path]];
    
    NSArray *parts = [[url path] componentsSeparatedByString:@"/"];
    
    if ([parts lastObject]) {
      [repoNameField setStringValue:[parts lastObject]];
      [repoWindow makeFirstResponder:repoNameField];
    }
  }
}

@end
