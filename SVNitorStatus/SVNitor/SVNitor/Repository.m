//
//  Repository.m
//  SVNitor
//
//  Created by Kevin Kinnebrew on 9/21/12.
//  Copyright (c) 2012 Letteer's Home. All rights reserved.
//

#import "Repository.h"

@implementation Repository

@synthesize name;
@synthesize repositoryPath;

- (id)init
{
  self = [super init];
  if (self) {
    name = [[NSString alloc] initWithString:@"My Repository"];
    repositoryPath = [[NSString alloc] initWithString:@"http://www.orangelit.com/myrepo"];
  }
  return self;
}

@end
