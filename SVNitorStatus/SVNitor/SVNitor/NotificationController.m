//
//  NotificationController.m
//  SVNitor
//
//  Created by Letteer on 9/22/12.
//  Copyright (c) 2012 Letteer's Home. All rights reserved.
//

#import "NotificationController.h"

@implementation NotificationController

- (id) init
{
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    return self;
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

-(void) displayNotification: (NSString *)title withDesc:(NSString *)description
{
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = title;
    notification.informativeText = description;
    notification.soundName = NSUserNotificationDefaultSoundName;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}
@end
