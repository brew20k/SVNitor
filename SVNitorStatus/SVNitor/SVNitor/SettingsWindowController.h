//
//  SettingsWindowController.h
//  SVNitor
//
//  Created by Kevin Kinnebrew on 9/19/12.
//  Copyright (c) 2012 Letteer's Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsWindowController : NSWindowController
{
  NSMutableArray *repositories;
}

@property (copy) NSMutableArray *repositories;

-(IBAction)addItem:(id)sender;
-(IBAction)removeItem:(id)sender;

@end
