//
//  GrowlAppDelegate.m
//  SVNitor
//
//  Created by Letteer on 9/22/12.
//  Copyright (c) 2012 Letteer's Home. All rights reserved.
//

#import "GrowlController.h"

@implementation GrowlController
- (id) init
{
  [GrowlApplicationBridge setGrowlDelegate:self];
  return self;
}

- (NSDictionary *) registrationDictionaryForGrowl
{
  NSString *path = [[NSBundle mainBundle] pathForResource:@"GrowlNotifications" ofType:@"plist"];
  growlNotifications = [NSDictionary dictionaryWithContentsOfFile:path];
  
  NSDictionary *regDict = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"SVNitor", GROWL_APP_NAME,
                           [growlNotifications objectForKey:@"ALL"], GROWL_NOTIFICATIONS_ALL,
                           [growlNotifications objectForKey:@"DEFAULT"],	GROWL_NOTIFICATIONS_DEFAULT,
                           [growlNotifications objectForKey:@"HUMAN_READABLE"],	GROWL_NOTIFICATIONS_HUMAN_READABLE_NAMES,
                           nil];
  return regDict;
}

- (void) notifyGrowl
{
		[GrowlApplicationBridge notifyWithTitle:@"SVNitor"
             description:@"SVNitor"
             notificationName:(NSString *) @"New SVN Commit"
             iconData:nil
             priority:0
             isSticky:YES
             clickContext:nil
             identifier:@"SVNitor identifier"];
}
@end
