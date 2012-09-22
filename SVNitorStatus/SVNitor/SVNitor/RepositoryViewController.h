//
//  RepositoryViewController.h
//  SVNitor
//
//  Created by Kevin Kinnebrew on 9/22/12.
//  Copyright (c) 2012 Letteer's Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RepositoryViewController : NSViewController <NSTableViewDataSource>
{
  NSMutableArray *repositories;
  NSTableView *table;
}

@property (copy) NSMutableArray *repositories;
@property (nonatomic, retain) IBOutlet NSTableView *table;

- (IBAction)addItem:(id)sender;
- (IBAction)removeItem:(id)sender;

@end
