//
//  ATBookmarkItemsMoveOperation.m
//  Bookmarks
//
//  Created by P,T,A on 09/08/13.
//  Copyright 2009 Nursery-Framework. All rights reserved.
//

#import "ATBookmarkItemsMoveOperation.h"
#import "ATItem.h"
#import "ATMoveOperationItem.h"

@implementation ATBookmarkItemsMoveOperation

+ (id)operation
{
	return [[self new] autorelease];
}

- (id)init
{
	[super init];
	
	items = [NSMutableArray new];
	
	return self;
}

- (void)add:(ATItem *)anItem movable:(BOOL)aMovable
{
	[items addObject:[ATMoveOperationItem moveOperationItemWith:anItem canMove:aMovable]];
}

- (NSEnumerator *)objectEnumerator
{
	return [items objectEnumerator];
}

- (void)dealloc
{
	[items release];
	items = nil;
	
	[super dealloc];
}

@end
