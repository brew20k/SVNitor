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
  NSWindow *modalWindow;
}

@property (nonatomic, retain) IBOutlet NSWindow *modalWindow;

- (IBAction)openWindow:(id)sender;

@end
