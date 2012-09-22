//
//  AppDelegate.h
//  SVNitor
//
//  Created by Kevin Kinnebrew on 9/18/12.
//  Copyright (c) 2012 Letteer's Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
  IBOutlet NSMenu *statusMenu;
  NSStatusItem *statusItem;
  NSMenuItem *quitBtn;
  NSWindowController *settingsWindow;
}

@property (assign) IBOutlet NSMenuItem *pauseBtn;
@property (assign) IBOutlet NSMenuItem *settingsBtn;
@property (assign) IBOutlet NSMenuItem *quitBtn;
@property (assign) IBOutlet NSMenuItem *aboutBtn;

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem;
- (IBAction)quitApplication:(id)sender;

- (NSString *) pathForDataFile;

- (void) saveData:(id)data forKey:(NSString *)key;
- (id) loadDataForKey:(NSString *)key;

@end
