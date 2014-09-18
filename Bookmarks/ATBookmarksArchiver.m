//
//  ATBookmarksArchiver.m
//  ATBookmarks
//
//  Created by 高田 明史 on 09/04/12.
//  Copyright 2009 Pedophilia. All rights reserved.
//

#import "ATBookmarksArchiver.h"
#import "ATBookmarks.h"
#import "ATItem.h"

@implementation ATBookmarksArchiver

+ (id)archive:(ATBookmarks *)aBookmarks
{
	return [[[[self alloc] initWithBookmarks:aBookmarks] autorelease] archive];
}

- (id)initWithBookmarks:(ATBookmarks *)aBookmarks
{
	[super init];
	
	bookmarks = [aBookmarks retain];
	itemsPlist = [NSMutableArray new];
	
	return self;
}

- (void)dealloc
{
	[bookmarks release];
	bookmarks = nil;
	
	[itemsPlist release];
	itemsPlist = nil;
	
	[archivedBookmarks release];
	archivedBookmarks = nil;
	
	[super dealloc];
}

- (id)archive
{
	NSEnumerator *anEnumerator = [[bookmarks itemLibrary] objectEnumerator];
	ATItem *anItem = nil;
	
	while (anItem = [anEnumerator nextObject])
	{
		[itemsPlist addObject:[anItem propertyListRepresentation]];
	}
	
	return [self makeArchivedBookmarks];
}

- (id)makeArchivedBookmarks
{
	archivedBookmarks = [[NSMutableDictionary dictionaryWithObjectsAndKeys:itemsPlist,@"items", [[bookmarks root] numberWithItemID],@"root", [[bookmarks idPool] propertyListRepresentation],@"idPool", [NSNumber numberWithDouble:1.0],@"version", nil] retain];
	
	return archivedBookmarks;
}

@end
