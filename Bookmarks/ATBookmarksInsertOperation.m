//
//  BookmarksInsertOperation.m
//  Bookmarks
//
//  Created by P,T,A  on 12/01/08.
//  Copyright (c) 2012年 PEDOPHILIA. All rights reserved.
//

#import "ATBookmarksInsertOperation.h"
#import "ATBinder.h"
#import "ATBookmarksRemoveOperation.h"

@implementation ATBookmarksInsertOperation

+ (id)insertOperationWithItems:(NSArray *)anItems index:(NSUInteger)anIndex binder:(ATBinder *)aBinder contextInfo:(id)anInfo
{
    return [[[self alloc] initWithItems:anItems index:anIndex binder:aBinder contextInfo:anInfo] autorelease];
}

+ (id)insertOperationWithItems:(NSArray *)anItems indexes:(NSIndexSet *)anIndexes binder:(ATBinder *)aBinder contectInfo:(id)anInfo
{
    return [[[self alloc] initWithItems:anItems indexes:anIndexes binder:aBinder contectInfo:anInfo] autorelease];
}

- (id)initWithItems:(NSArray *)anItems index:(NSUInteger)anIndex binder:(ATBinder *)aBinder contextInfo:(id)anInfo
{
    return [self initWithItems:anItems indexes:[[NSMutableIndexSet alloc] initWithIndexesInRange:NSMakeRange(anIndex, [anItems count])] binder:aBinder contectInfo:anInfo];
}

- (id)initWithItems:(NSArray *)anItems indexes:(NSIndexSet *)anIndexes binder:(ATBinder *)aBinder contectInfo:(id)anInfo
{
    [super init];
    
    items = [anItems mutableCopy];
    indexes = [anIndexes mutableCopy];
    binder = [aBinder retain];
    contextInfo = [anInfo retain];
    
    return self;
}

- (ATBookmarksOperation *)undoOperation
{
    return [ATBookmarksRemoveOperation removeOperationWithIndexes:indexes binder:binder contextInfo:contextInfo];
}

@end
