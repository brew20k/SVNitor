//
//  LogMessage.h
//  SVNitor
//
//  Created by Kevin Kinnebrew on 9/22/12.
//  Copyright (c) 2012 Letteer's Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogMessage : NSObject
{
  NSString *revisionNumber;
  NSString *author;
  NSInteger *changedFiles;
  NSString *message;
}

@property (copy) NSString *revisionNumber;
@property (copy) NSString *author;
@property NSInteger *changedFiles;
@property (copy) NSString *message;

- (id)initWithString:(NSString *)log;

@end
