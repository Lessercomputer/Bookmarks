//
//  ATNurserySpecifyingInfo.m
//  Bookmarks
//
//  Created by Akifumi Takata on 2015/07/24.
//  Copyright (c) 2015年 Nursery-Framework. All rights reserved.
//

#import "ATNurserySpecifyingInfo.h"
#import <Nursery/Nursery.h>

@implementation ATNurserySpecifyingInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        hostName = @"";
        nurseryName = @"";
    }
    return self;
}

- (NSString *)hostName
{
    return hostName;
}

- (void)setHostName:(NSString *)aName
{
    [hostName autorelease];
    hostName = [aName copy];
}

- (NSString *)nurseryName
{
    return nurseryName;
}

- (void)setNurseryName:(NSString *)aName
{
    [self willChangeValueForKey:@"nurseryName"];
    
    [nurseryName autorelease];
    nurseryName = [aName copy];
    
    [self didChangeValueForKey:@"nurseryName"];
}

- (NSURL *)nurseryURL
{
    return [[[NSURL alloc] initWithScheme:@"nursery" host:[self hostName] path:[self nurseryName]] autorelease];
}

@end
