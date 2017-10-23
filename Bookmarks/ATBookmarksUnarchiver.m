//
//  BookmarksUnarchiver.m
//  Bookmarks
//
//  Created by P,T,A on 09/04/18.
//  Copyright 2009 Nursery-Framework. All rights reserved.
//

#import "ATBookmarksUnarchiver.h"
#import "ATItem.h"
#import "ATBinder.h"
#import "ATBookmarks.h"
#import "ATIDPool.h"
#import "ATBookmarksTreeUnarchiver.h"

@implementation ATBookmarksUnarchiver

+ (id)unarchive:(NSDictionary *)anArchive
{
	NSNumber *aVersion = [anArchive objectForKey:@"version"];
	
	if ([aVersion doubleValue] == 0.2)
		return [[[[ATBookmarksTreeUnarchiver alloc] initWithArchive:anArchive] autorelease] unarchive];
	else if ([aVersion doubleValue] == 0.3 || [aVersion doubleValue] == 1.0)
		return [[[[self alloc] initWithArchive:anArchive] autorelease] unarchive];
	else
		return nil;
}

- (id)initWithArchive:(id)anArchive
{
	[super init];
	
	archivedBookmarks = [anArchive retain];
	
	return self;
}

- (void)dealloc
{
	[archivedBookmarks release];
	archivedBookmarks = nil;
	
	[unarchivedItems release];
	unarchivedItems = nil;
	
	[binders release];
	binders = nil;
	
	[super dealloc];
}

- (id)unarchive
{
	[self prepareUnarchivedItems];
	[self establishBinders];
	return [self makeBookmarks];
}

- (void)prepareUnarchivedItems
{
	NSArray *anArchivedItems = [archivedBookmarks objectForKey:@"items"];
	NSEnumerator *anEnumerator = [anArchivedItems objectEnumerator];
	NSDictionary *anItemDictionary = nil;
	
	unarchivedItems = [NSMutableDictionary new];
	binders = [NSMutableArray new];
	
	while (anItemDictionary = [anEnumerator nextObject])
	{
		ATItem *anItem = [[NSClassFromString([anItemDictionary objectForKey:@"class"]) newWith:anItemDictionary] autorelease];
		
		[unarchivedItems setObject:anItem forKey:[anItem numberWithItemID]];
		
		if ([anItem isKindOfClass:[ATBinder class]])
			[binders addObject:anItemDictionary];
	}
}

- (void)establishBinders
{
	NSEnumerator *anEnumerator = [binders objectEnumerator];
	NSDictionary *aBinderDictionary = nil;
	
	while (aBinderDictionary = [anEnumerator nextObject])
	{
		ATBinder *aBinder = [unarchivedItems objectForKey:[aBinderDictionary objectForKey:@"itemID"]];
		NSArray *aChildren = [aBinderDictionary objectForKey:@"children"];
		
		[self establishBinder:aBinder children:aChildren];
	}
}

- (void)establishBinder:(ATBinder *)aBinder children:(NSArray *)aChildren
{
	NSEnumerator *anEnumerator = [aChildren objectEnumerator];
	NSNumber *aChildItemID = nil;
	
	while (aChildItemID = [anEnumerator nextObject])
	{
		[aBinder add:[unarchivedItems objectForKey:aChildItemID]];
	}
}

- (ATBookmarks *)makeBookmarks
{
	return [[[ATBookmarks alloc] initWithIDPool:[self idPool] items:unarchivedItems root:[self rootBinder]] autorelease];
}

- (ATBinder *)rootBinder
{
	return [unarchivedItems objectForKey:[archivedBookmarks objectForKey:@"root"]];
}

- (ATIDPool *)idPool
{
	return [[[ATIDPool alloc] initWith:[archivedBookmarks objectForKey:@"idPool"]] autorelease];
}

@end
