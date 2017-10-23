//
//  ATNurserySpecifyingInfo.m
//  Bookmarks
//
//  Created by P,T,A on 2015/07/24.
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
        nurseryAssociationName = NUDefaultMainBranchAssociation;
        useDefaultNurseryAssociationName = YES;
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
    
    [self updateNurseryURL];
}

- (NSString *)nurseryAssociationName
{
    return nurseryAssociationName;
}

- (void)setNurseryAssociationName:(NSString *)aName
{
    [nurseryAssociationName autorelease];
    nurseryAssociationName = [aName copy];
    
    [self updateNurseryURL];
}

- (BOOL)useDefaultNurseryAssociationName
{
    return useDefaultNurseryAssociationName;
}

- (void)setUseDefaultNurseryAssociationName:(BOOL)aUseFlag
{
    useDefaultNurseryAssociationName = aUseFlag;
    
    if (useDefaultNurseryAssociationName)
        [self setNurseryAssociationName:NUDefaultMainBranchAssociation];
}

- (NSString *)nurseryName
{
    return nurseryName;
}

- (void)setNurseryName:(NSString *)aName
{
    [nurseryName autorelease];
    nurseryName = [aName copy];
    
    [self updateNurseryURL];
}

- (NSURL *)nurseryURL
{
    return nurseryURL;
}

- (void)updateNurseryURL
{
    [self setNurseryURL:[NUNurseryAssociation URLWithHostName:hostName associationName:nurseryAssociationName nurseryName:nurseryName]];
}

- (void)setNurseryURL:(NSURL *)aURL
{
    [self willChangeValueForKey:@"nurseryURL"];
    [nurseryURL autorelease];
    nurseryURL = [aURL copy];
    [self didChangeValueForKey:@"nurseryURL"];
}

@end
