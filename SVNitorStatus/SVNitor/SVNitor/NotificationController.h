//
//  NotificationController.h
//  SVNitor
//
//  Created by Letteer on 9/22/12.
//  Copyright (c) 2012 Letteer's Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NotificationController : NSObject <NSUserNotificationCenterDelegate>
{
}
-(void) displayNotification: (NSString *)title withDesc:(NSString *)description;

@end
