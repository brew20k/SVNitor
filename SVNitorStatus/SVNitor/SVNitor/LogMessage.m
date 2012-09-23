//
//  LogMessage.m
//  SVNitor
//
//  Created by Kevin Kinnebrew on 9/22/12.
//  Copyright (c) 2012 Letteer's Home. All rights reserved.
//

#import "LogMessage.h"

@implementation LogMessage

@synthesize revisionNumber;
@synthesize author;
@synthesize date;
@synthesize changedFiles;
@synthesize message;

- (id)initWithString:(NSString *)log
{
  self = [super init];
  if (self) {
    
    NSLog(@"message: %@", log);
    NSArray *parts = [log componentsSeparatedByString:@"\n"];
    NSLog(@"message: %i", (int)[parts count]);
    
    for (int i=0; i<(int)[parts count]; i++) {
      NSLog(@"message: %@", [parts objectAtIndex:i]);
    }
    
  }
  return self;
}

@end
