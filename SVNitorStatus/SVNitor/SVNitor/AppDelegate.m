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

#pragma mark -
#pragma mark Initialization

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  // setup status menu
  [statusMenu setAutoenablesItems:YES];
  
  // initialize growl controller
  growlController = [[GrowlController alloc] init];
  
  // check for changes
  [self pollForChanges];
  
  // poll at 90 second interval
  [NSTimer scheduledTimerWithTimeInterval:90 target:self selector:@selector(pollForChanges) userInfo:nil repeats:YES];
}

- (void)awakeFromNib
{
  // generate new status item
  statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  
  // bind to status mar
  [statusItem setMenu:statusMenu];
  
  // load images
  NSImage *image = [NSImage imageNamed:@"Icon.png"];
  NSImage *altImage = [NSImage imageNamed:@"IconAlt.png"];
  
  // bind images to status item
  [statusItem setImage:image];
  [statusItem setAlternateImage:altImage];
  
  // highlight on click
  [statusItem setHighlightMode:YES];
}

-(BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
  return YES;
}

#pragma mark -
#pragma mark User Actions

-(IBAction)quitApplication:(id)sender
{
  [NSApp terminate: nil];
}

-(IBAction)openSettings:(id)sender
{
  settingsWindow = [[SettingsWindowController alloc] initWithWindowNibName:@"SettingsWindow"];
  [settingsWindow showWindow:nil];
}

#pragma mark -
#pragma mark Data Storage

/**
 * Returns the path for the settings file containing the list of
 * repositories to load.
 * @return NSString
 */
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

#pragma mark -
#pragma mark Polling

- (void)pollForChanges
{
  NSArray *repos = [self loadDataForKey:@"repository"];
  
  for (int i=0; i<[repos count]; i++)
  {
    NSLog(@"%@", [[repos objectAtIndex:i] repositoryPath]);
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
  
  NSMutableArray *repositories = [(AppDelegate *)[[NSApplication sharedApplication] delegate] loadDataForKey:@"repository"];
  
  Repository *repo;
  
  for (int i=0; i<[repositories count]; i++)
  {
    if ([[[repositories objectAtIndex:i] repositoryPath] isEqualToString:repoPath]) {
      repo = [repositories objectAtIndex:i];
      break;
    }
  }
  
  NSString *plural;
  NSString *title;
  
  NSString *description = [NSString stringWithFormat:@"Committed by: %@", [message author]];
  
  NSString *currentRevision = [repo revision];
  NSString *messageRevision = [message revisionNumber];
  
  if (repo && ![currentRevision isEqualToString:messageRevision])
  {
    
    if (repo )
    
    if ((int)[message changedFiles] == 1) {
      plural = @"File";
    } else if ((int)[message changedFiles] > 1) {
      plural = @"Files";
    }
    
    title = [NSString stringWithFormat:@"%i %@ Changed", (int)[message changedFiles], plural];

    [growlController notifyGrowl:title withDesc:description];
    
    [repo setRevision:currentRevision];
    
    [(AppDelegate *)[[NSApplication sharedApplication] delegate] saveData:repositories forKey:@"repository"];
  }

}

#pragma mark -
#pragma mark Configuration

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
