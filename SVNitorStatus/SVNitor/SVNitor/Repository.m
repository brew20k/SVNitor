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

- (id) initWithCoder: (NSCoder *)coder
{
  if (self = [super init])
  {
    [self setName: [coder decodeObjectForKey:@"name"]];
    [self setRepositoryPath: [coder decodeObjectForKey:@"repositoryPath"]];
  }
  return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
  [coder encodeObject:name forKey:@"name"];
  [coder encodeObject:repositoryPath forKey:@"repositoryPath"];
}

@end
