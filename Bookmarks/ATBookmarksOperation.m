//
//  BookmarksOperation.m
//  Bookmarks
//
//  Created by 高田 明史  on 12/01/08.
//  Copyright (c) 2012年 Pedophilia. All rights reserved.
//

#import "ATBookmarksOperation.h"

@implementation ATBookmarksOperation

- (NSMutableArray *)items
{
    return items;
}

- (NSMutableIndexSet *)indexes
{
    return indexes;
}

- (ATBinder *)binder
{
    return binder;
}

- (id)contextInfo
{
    return contextInfo;
}

- (void)dealloc
{
    [items release];
    [indexes release];
    [binder release];
    [contextInfo release];
    
    [super dealloc];
}

- (ATBookmarksOperation *)undoOperation
{
    return nil;
}

@end
