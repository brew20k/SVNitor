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
  if([GrowlApplicationBridge isGrowlRunning])
  {
    [GrowlApplicationBridge setGrowlDelegate:self];
  }
  else
  {
    //TODO: implement automatic pause of notifications.
  }
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

-(void) notifyGrowl: (NSString *)title withDesc:(NSString *)description
{
    NSString *notificationName = [[growlNotifications objectForKey:@"ALL"] valueForKey:@"NotiferNewCommit"];
		[GrowlApplicationBridge notifyWithTitle:title
             description:description
             notificationName:(NSString *)[[growlNotifications objectForKey:@"ALL"] valueForKey:@"NotifierNewCommit"]
             iconData:nil
             priority:0
             isSticky:YES
             clickContext:nil
             identifier:@"SVNitor identifier"];
}
@end
