//
//  BookmarksEnumerator.m
//  Bookmarks
//
//  Created by Akifumi Takata on 09/06/20.
//  Copyright 2009 Nursery-Framework. All rights reserved.
//

#import "ATBookmarksEnumerator.h"
#import "ATBinder.h"

@implementation ATBookmarksEnumerator

+ (id)enumeratorWithBinder:(ATBinder *)aBinder
{
	return [[[self alloc] initWithBinder:aBinder] autorelease];
}

+ (id)enumeratorWithBinders:(NSArray *)aBinders
{
	return [[[self alloc] initWithBinders:aBinders] autorelease];
}

- (id)initWithBinder:(ATBinder *)aBinder
{
	return [self initWithBinders:[aBinder children]];
}

- (id)initWithBinders:(NSArray *)aBinders
{
	[super init];
	
	binders = [aBinders copy];
	visitedItems = [NSMutableSet new];
	stack = [[NSMutableArray arrayWithObject:[aBinders objectEnumerator]] retain];
	
	return self;
}

- (id)nextObject
{
	id aNextItem = nil;
	
	while (!aNextItem && [stack count])
	{
		id anItem = [[stack lastObject] nextObject];
		
		if (!anItem)
			[stack removeLastObject];
		else if (![visitedItems containsObject:anItem])
		{
			aNextItem = anItem;
			[visitedItems addObject:aNextItem];
			
			if ([aNextItem isFolder])
				[stack addObject:[aNextItem objectEnumerator]];
		}
	}
	
	return aNextItem;
}

- (void)dealloc
{
	[binders release];
	[visitedItems release];
	[stack release];
	
	[super dealloc];
}

@end
