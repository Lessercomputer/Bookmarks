//
//  BookmarksItemsUnarchiver.m
//  Bookmarks
//
//  Created by 高田 明史 on 09/03/26.
//  Copyright 2009 Pedophilia. All rights reserved.
//

#import "ATBookmarksItemsUnarchiver.h"
#import "ATBinder.h"

@implementation ATBookmarksItemsUnarchiver

+ (id)unarchive:(NSDictionary *)anArchive
{
	return [[[[self alloc] initWithArchive:anArchive] autorelease] unarchive];
}

- (id)initWithArchive:(id)anArchive
{
	[super init];
	
	itemsArchive = [anArchive retain];
	unarchivedItems = [NSMutableDictionary new];
	toplevelItems = [NSMutableArray new];
	
	return self;
}

- (void)dealloc
{
	[itemsArchive release];
	itemsArchive = nil;
	
	[unarchivedItems release];
	unarchivedItems = nil;
	
	[toplevelItems release];
	toplevelItems = nil;
	
	[super dealloc];
}

- (id)unarchive
{
	[self prepareUnarchivedItemsFromArchive];
	[self establishBinders];
	
	return [NSDictionary dictionaryWithObjectsAndKeys:[self toplevelItems],@"toplevelItems", [itemsArchive objectForKey:@"sourceBinderID"],@"sourceBinderID", nil];
}

- (void)prepareUnarchivedItemsFromArchive
{
	NSEnumerator *anEnumerator = [[itemsArchive objectForKey:@"items"] objectEnumerator];
	NSDictionary *anItemDictionary = nil;
	
	while (anItemDictionary = [anEnumerator nextObject])
	{
		id anItem = [[NSClassFromString([anItemDictionary objectForKey:@"class"]) newWith:anItemDictionary] autorelease];
		
		[unarchivedItems setObject:anItem forKey:[anItemDictionary objectForKey:@"itemID"]];
	}
}

- (void)establishBinders
{
	NSEnumerator *anEnumerator = [[itemsArchive objectForKey:@"items"] keyEnumerator];
	id anItemID = nil;
	
	while (anItemID = [anEnumerator nextObject])
	{
		anItemID = [NSNumber numberWithUnsignedInteger:[anItemID intValue]];
		id anItem = [unarchivedItems objectForKey:anItemID];
		
		if ([anItem isFolder])
		{
			ATBinder *aBinder = [unarchivedItems objectForKey:anItemID];
			
			[self establishBinder:aBinder itemID:anItemID];
		}
	}
}

- (void)establishBinder:(ATBinder *)aBinder itemID:(NSNumber *)aBinderID
{
	NSEnumerator *anEnumerator = [itemsArchive[@"items"][[aBinderID stringValue]][@"children"] objectEnumerator];
	NSNumber *aChildItemID = nil;
	
	while (aChildItemID = [anEnumerator nextObject])
		[aBinder add:[unarchivedItems objectForKey:aChildItemID]];
}

- (id)toplevelItems
{
	NSEnumerator *anEnumerator = [[itemsArchive objectForKey:@"toplevelItems"] objectEnumerator];
	NSNumber *anItemID = nil;
	
	while (anItemID = [anEnumerator nextObject])
		[toplevelItems addObject:[unarchivedItems objectForKey:anItemID]];
		
	return toplevelItems;
}

@end
