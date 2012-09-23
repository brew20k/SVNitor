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
@synthesize changedFiles;
@synthesize message;

- (id)initWithString:(NSString *)log
{
  self = [super init];
  if (self) {
    
    NSArray *parts = [log componentsSeparatedByString:@"\n"];
    NSString *info;
    NSMutableArray *files = [[NSMutableArray alloc] init];
    NSString *message = @"";
    
    int messageLine = -1;
    int changedLine = -1;
    
    for (int i=0; i<(int)[parts count]; i++) {
      if (i == 1 && [[[parts objectAtIndex:i] substringToIndex:1] isEqualToString:@"r"])
      {
        info = [parts objectAtIndex:i];
        changedLine = i+2;
      } else if (messageLine == -1 && changedLine != -1 && i >= changedLine) {
        if ([[parts objectAtIndex:i] length] == 0) {
          messageLine = i+1;
          changedLine = -1;
        } else {
          [files addObject:[parts objectAtIndex:i]];
        }
      } else if (messageLine != -1 && [[parts objectAtIndex:i] length] != 0) {
        if (![[[parts objectAtIndex:i] substringToIndex:1] isEqualToString:@"-"]) {
          NSString *partial = [@" " stringByAppendingString:[parts objectAtIndex:i]];
          message = [message stringByAppendingString:partial];
        }
      }
    }
        
    [self setMessage:[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    
    [self setChangedFiles:(NSInteger *)[files count]];
    
    // parse info string
    if ([info length] > 0) {
      
      NSArray *infoParts = [info componentsSeparatedByString:@"|"];
      
      NSString *revisionNumber = [[infoParts objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
      NSString *author = [[infoParts objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
      
      [self setRevisionNumber:revisionNumber];
      [self setAuthor:author];
      
    }
    NSLog(@"author: %@, changed: %i", author, (int)changedFiles);
    
  }
  return self;
}

@end
