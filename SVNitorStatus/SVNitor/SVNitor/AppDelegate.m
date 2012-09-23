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
#import "LogMessage.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  // Insert code here to initialize your application
  [statusMenu setAutoenablesItems:YES];
  
  growlController = [[GrowlController alloc] init];
  
  // Poll for changes
  [self pollForChanges];
  [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(pollForChanges) userInfo:nil repeats:YES];
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
  
  NSString *fileName = @"Settings.xml";
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

- (void)pollForChanges
{
  NSArray *repos = [self loadDataForKey:@"repository"];
  
  for (int i=0; i<[repos count]; i++)
  {
    [self pollPath:[(Repository *)[repos objectAtIndex:i] repositoryPath]];
  }
  
  NSLog(@"Poll complete");
}

- (void)pollPath:(NSString *)repoPath
{
  NSLog(@"Checking %@ for changes", repoPath);

  NSString *path = @"/usr/bin/svn";
  NSArray *args = [NSArray arrayWithObjects:@"log", repoPath, @"-l", @"1", @"-v", nil];

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
  
  NSString *title;
  if ((int)[message changedFiles] == 1) {
    title = [NSString stringWithFormat:@"%i File Changed", (int)[message changedFiles]];
  } else if ((int)[message changedFiles] > 1) {
    title = [NSString stringWithFormat:@"%i Files Changed", (int)[message changedFiles]];
  }
  NSString *description = [NSString stringWithFormat:@"Committed by: %@", [message author]];
  
  [growlController notifyGrowl:title withDesc:description];

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

@end
