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
@end
