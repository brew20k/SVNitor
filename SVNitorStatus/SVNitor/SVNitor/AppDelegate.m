//
//  AppDelegate.m
//  SVNitor
//
//  Created by Kevin Kinnebrew on 9/18/12.
//  Copyright (c) 2012 Letteer's Home. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsWindowController.h"
#import "GrowlController.h"
#import "Repository.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  // Insert code here to initialize your application
  [statusMenu setAutoenablesItems:YES];
  NSMutableArray *array = [[NSMutableArray alloc] init];
  [array addObject:[[Repository alloc] init]];
  [array addObject:[[Repository alloc] init]];
  [self saveData:array forKey:@"repository"];
}

- (void)awakeFromNib
{
  statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  [statusItem setMenu:statusMenu];
  [statusItem setTitle:@"S"];
  [statusItem setHighlightMode:YES];
}

-(BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
  return YES;
}

-(IBAction)quitApplication:(id)sender
{
  [NSApp terminate: nil];
}

-(IBAction)notifyGrowl:(id)sender
{
  growlController = [[GrowlController alloc] init];

}

-(IBAction)openSettings:(id)sender
{
  settingsWindow = [[SettingsWindowController alloc] initWithWindowNibName:@"SettingsWindow"];
  [settingsWindow showWindow:nil];
}

- (NSString *)pathForDataFile
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
  
  NSString *folder = @"~/Library/Application Support/SVNitor/";
  folder = [folder stringByExpandingTildeInPath];
  
  if ([fileManager fileExistsAtPath: folder] == NO)
  {
    [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
  }
  
  NSString *fileName = @"Settings";
  return [folder stringByAppendingPathComponent: fileName];
}

- (void)saveData:(id)data forKey:(NSString *)key
{
  NSString * path = [self pathForDataFile];
  
  NSMutableDictionary * rootObject;
  rootObject = [NSMutableDictionary dictionary];
  
  [rootObject setValue:data forKey:key];
  [NSKeyedArchiver archiveRootObject: rootObject toFile: path];
}

- (id)loadDataForKey:(NSString *)key
{
  NSString     * path        = [self pathForDataFile];
  NSDictionary * rootObject;
  
  rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
  return [rootObject valueForKey:key];
}

@end
