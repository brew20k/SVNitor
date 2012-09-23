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

//- (IBAction)addItem:(id)sender
//{
//  [repositories addObject:[[Repository alloc] init]];
//  NSIndexSet *index = [[NSIndexSet alloc] initWithIndex:([repositories count] - 1)];
//  [table selectRowIndexes:index byExtendingSelection:NO];
//  [table editColumn:0 row:([repositories count] - 1) withEvent:nil select:YES];
//  [(AppDelegate *)[[NSApplication sharedApplication] delegate] saveData:repositories forKey:@"repository"];
//  [table reloadData];
//}

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

- (IBAction)saveRepo:(id)sender
{
  NSString *repoName = [repoNameField stringValue];
  NSString *repoPath = [repoPathField stringValue];
  
  Repository *repo = [[Repository alloc] init];
  [repo setName:repoName];
  [repo setRepositoryPath:repoPath];
  
  [repositories addObject:repo];
  [(AppDelegate *)[[NSApplication sharedApplication] delegate] saveData:repositories forKey:@"repository"];
  [table reloadData];
  
  [NSApp endSheet:modalWindow];
  [modalWindow orderOut:modalWindow];
  
  NSString *path = @"/usr/bin/svn";
  NSArray *args = [NSArray arrayWithObjects:@"log", @"https://kkinnebrew@svn.westmonroepartners.com/svnldap/Clients/U-V/USF/USF-Chicago-MPO", @"-l", @"1", @"-v", nil];
  
  NSPipe *pipe = [NSPipe pipe];
  
  NSTask *task = [[NSTask alloc] init];
  [task setStandardOutput:pipe];
  [task setLaunchPath:path];
  [task setArguments:args];
  
  [task launch];
  
  NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];
  
  [task waitUntilExit];
  
  NSString *changes = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  
  LogMessage *message = [[LogMessage alloc] initWithString:changes];
  
}

- (NSString *)getSVNLocation
{
  NSString *path = @"/usr/bin/whereis";
  NSArray *args = [NSArray arrayWithObjects:@"svn", nil];
  
  NSPipe *pipe = [NSPipe pipe];
  
  NSTask *task = [[NSTask alloc] init];
  [task setStandardOutput:pipe];
  [task setLaunchPath:path];
  [task setArguments:args];
  
  [task launch];
  
  NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];
  
  [task waitUntilExit];
  
  NSString *location = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  NSLog(@"%@", location);
    
  return location;
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
