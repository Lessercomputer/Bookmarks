//
//  BookmarksTreeUnarchiver.m
//  Bookmarks
//
//  Created by P,T,A on 09/05/02.
//  Copyright 2009 PEDOPHILIA. All rights reserved.
//

#import "ATBookmarksTreeUnarchiver.h"
#import "ATIDPool.h"
#import "ATBinder.h"
#import "ATBookmarksTreeEnumerator.h"
#import "ATBookmarks.h"
#import "ATBookmark.h"


@implementation ATBookmarksTreeUnarchiver

- (id)initWithArchive:(id)anArchive
{
	[super init];
	
	archive = [anArchive retain];
	root = [ATBinder newWith:anArchive[@"root"]];
	currentBinder = root;
	itemsDictionary = [[NSMutableDictionary dictionaryWithObject:root forKey:[root numberWithItemID]] retain];
	
	return self;
}

- (void)dealloc
{
	[archive release];
	archive = nil;
	
	[root release];
	root = nil;
	
	[itemsDictionary release];
	itemsDictionary = nil;
	
	[super dealloc];
}

- (id)unarchive
{
	ATIDPool *anIDPool = [[[ATIDPool alloc] initWith:[archive objectForKey:@"idPool"]] autorelease];
	ATBookmarksTreeEnumerator *anEnumerator = [[[ATBookmarksTreeEnumerator alloc] initWithRoot:[archive objectForKey:@"root"] delegate:self upSelector:@selector(enumeratorGoUp)] autorelease];
	NSDictionary *anItemDictionary = nil;
	
	while (anItemDictionary = [anEnumerator nextObject])
	{
		ATItem *anItem = nil;
		
		if ([[anItemDictionary objectForKey:@"class"] isEqualToString:@"ATFolder"])
		{
			anItem = [[ATBinder newWith:anItemDictionary] autorelease];
			[currentBinder add:anItem];
			currentBinder = (ATBinder *)anItem;
		}
		else
		{
			anItem = (ATItem *)[[ATBookmark newWith:anItemDictionary] autorelease];
			[currentBinder add:anItem];
		}
		
		[itemsDictionary setObject:anItem forKey:[anItem numberWithItemID]];
	}
	
	return [[[ATBookmarks alloc] initWithIDPool:anIDPool items:itemsDictionary root:root] autorelease];
}

- (void)enumeratorGoUp
{
	currentBinder = [[currentBinder binders] firstObject];
}

@end
