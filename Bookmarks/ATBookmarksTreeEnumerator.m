//
//  BookmarksTreeEnumerator.m
//  Bookmarks
//
//  Created by Akifumi Takata on 09/05/02.
//  Copyright 2009 Nursery-Framework. All rights reserved.
//

#import "ATBookmarksTreeEnumerator.h"


@implementation ATBookmarksTreeEnumerator

- (id)initWithRoot:(NSDictionary *)aRoot delegate:(id)aDelegate upSelector:(SEL)aSelector
{
	[super init];
	
	root = [aRoot retain];
	stack = [[NSMutableArray arrayWithObject:[[aRoot objectForKey:@"children"] objectEnumerator]] retain];
	delegate = aDelegate;
	upSelector = aSelector;
	
	return self;
}

- (void)dealloc
{
	[root release];
	root = nil;
	
	[stack release];
	stack = nil;
	
	[super dealloc];
}

- (id)nextObject
{
	NSDictionary *anItemDictionary = nil;
	
	while (!anItemDictionary && [stack count])
	{
		anItemDictionary = [[stack lastObject] nextObject];
		
		if (anItemDictionary)
		{
			if ([[anItemDictionary objectForKey:@"class"] isEqualToString:@"ATFolder"])
				[stack addObject:[[anItemDictionary objectForKey:@"children"] objectEnumerator]];
		}
		else
		{
			[stack removeLastObject];
			[delegate performSelector:upSelector];
		}
	}
	
	return anItemDictionary;
}

@end
