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
        serviceName = @"";
    }
    return self;
}

- (NSString *)serviceName
{
    return serviceName;
}

- (void)setServiceName:(NSString *)aName
{
    [self willChangeValueForKey:@"serviceName"];
    
    [serviceName autorelease];
    serviceName = [aName copy];
    
    [self didChangeValueForKey:@"serviceName"];
}

- (NSURL *)nurseryURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"nursery://%@", [self serviceName]]];
}

@end
