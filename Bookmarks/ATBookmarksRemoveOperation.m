//
//  ATBookmarksRemoveOperation.m
//  ATBookmarks
//
//  Created by 高田 明史  on 12/01/08.
//  Copyright (c) 2012年 Pedophilia. All rights reserved.
//

#import "ATBookmarksRemoveOperation.h"
#import "ATBookmarksInsertOperation.h"
#import "ATBinder.h"

@implementation ATBookmarksRemoveOperation

+ (id)removeOperationWithIndexes:(NSIndexSet *)anIndexes binder:(ATBinder *)aBinder  contextInfo:(id)anInfo
{
    return [[[self alloc] initWithIndexes:anIndexes binder:aBinder contextInfo:anInfo] autorelease];
}

- (id)initWithIndexes:(NSIndexSet *)anIndexes binder:(ATBinder *)aBinder  contextInfo:(id)anInfo
{
    [super init];
    
    indexes = [anIndexes mutableCopy];
    binder = [aBinder retain];
    contextInfo = [anInfo retain];
    
    return self;
}

- (ATBookmarksOperation *)undoOperation
{
    return [ATBookmarksInsertOperation insertOperationWithItems:[binder atIndexes:indexes] indexes:indexes binder:binder contectInfo:contextInfo];
}

@end
