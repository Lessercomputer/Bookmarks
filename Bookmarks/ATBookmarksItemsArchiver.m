//
//  BookmarksArchiver.m
//  Bookmarks
//
//  Created by P,T,A on 09/03/24.
//  Copyright 2009 Nursery-Framework. All rights reserved.
//

#import "ATBookmarksItemsArchiver.h"
#import "ATItem.h"


@implementation ATBookmarksItemsArchiver

+ (id)archiveItem:(ATItem *)anItem source:(ATBinder *)aSourceBinder
{
	return [self archiveItems:[NSArray arrayWithObject:anItem] source:aSourceBinder];
}

+ (id)archiveItems:(NSArray *)anItems source:(ATBinder *)aSourceBinder
{
	return [[[[self alloc] initWithItems:anItems source:aSourceBinder] autorelease] archive];
}

- (id)initWithItems:(NSArray *)anItems source:(ATBinder *)aSourceBinder
{
	[super init];
	
	visitedItems = [NSMutableSet new];
	root = [anItems retain];
	source = [aSourceBinder retain];
	enumerators = [NSMutableArray new];
	[enumerators addObject:[root objectEnumerator]];
	
	itemsPlist = [NSMutableDictionary new];
	toplevelItems = [NSMutableArray new];

	return self;
}
	
- (void)dealloc
{
	[visitedItems release];
	visitedItems = nil;
	
	[root release];
	root = nil;
	
	[source release];
	source = nil;
	
	[enumerators release];
	enumerators = nil;
	
	[itemsPlist release];
	itemsPlist = nil;
	
	[toplevelItems release];
	toplevelItems = nil;
	
	[itemsArchive release];
	itemsArchive = nil;

	[super dealloc];
}

- (id)archive
{
	while ([enumerators count])
	{
		ATItem *anItem = [[enumerators lastObject] nextObject];

		if (anItem)
		{
			if (![visitedItems containsObject:anItem])
			{
				[visitedItems addObject:anItem];
				
				if ([anItem isFolder])
					[enumerators addObject:[(ATBinder *)anItem objectEnumerator]];
					
				[itemsPlist setObject:[anItem propertyListRepresentation] forKey:[[anItem numberWithItemID] stringValue]];
			}
		}
		else
			[enumerators removeLastObject];				
	}			
	
	[self convertRootToToplevelItems];
	[self makeItemsArchive];
	
	return itemsArchive;
}

- (void)convertRootToToplevelItems
{
	NSEnumerator *anEnumerator = [root objectEnumerator];
	ATItem *anItem = nil;
	
	while (anItem = [anEnumerator nextObject])
		[toplevelItems addObject:[anItem numberWithItemID]];
}

- (void)makeItemsArchive
{
	itemsArchive = [[NSDictionary alloc] initWithObjectsAndKeys:toplevelItems,@"toplevelItems", itemsPlist,@"items", [source numberWithItemID],@"sourceBinderID", nil];
}

- (NSData *)dataWithArchivedItems
{
	NSString *anErrorString = nil;
		
	return [NSPropertyListSerialization dataFromPropertyList:[self archive] format:NSPropertyListXMLFormat_v1_0 errorDescription:&anErrorString];

}

@end
