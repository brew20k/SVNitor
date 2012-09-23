//
//  RepositoryViewController.h
//  SVNitor
//
//  Created by Kevin Kinnebrew on 9/22/12.
//  Copyright (c) 2012 Letteer's Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RepositoryViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>
{
  NSMutableArray *repositories;
  NSTableView *table;
  NSWindow *modalWindow;
  NSWindow *repoWindow;
  NSTextField *repoPathField;
  NSTextField *repoNameField;
}

@property (nonatomic, retain) IBOutlet NSWindow *modalWindow;
@property (nonatomic, retain) IBOutlet NSWindow *repoWindow;

@property (nonatomic, retain) IBOutlet NSTextField *repoPathField;
@property (nonatomic, retain) IBOutlet NSTextField *repoNameField;

@property (copy) NSMutableArray *repositories;
@property (nonatomic, retain) IBOutlet NSTableView *table;

//- (IBAction)addItem:(id)sender;
- (IBAction)removeItem:(id)sender;

- (IBAction)openWindow:(id)sender;
- (IBAction)saveRepo:(id)sender;
- (IBAction)closeWindow:(id)sender;

- (IBAction)browseToFile:(id)sender;


@end
