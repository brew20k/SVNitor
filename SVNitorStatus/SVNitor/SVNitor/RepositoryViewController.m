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
  NSLog(@"repositories %i", (int)[repositories count]);
  return [repositories count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  if ([tableColumn identifier] == @"name") {
    return [[repositories objectAtIndex:row] name];
  } else {
    return [[repositories objectAtIndex:row] repositoryPath];
  }
}

@end
