//
//  GrowlAppDelegate.h
//  SVNitor
//
//  Created by Letteer on 9/22/12.
//  Copyright (c) 2012 Letteer's Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>

@interface GrowlController : NSObject <GrowlApplicationBridgeDelegate>
{
  NSDictionary *growlNotifications;
}

-(void) notifyGrowl;

@end
