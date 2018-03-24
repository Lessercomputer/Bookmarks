//
//  BookmarksArchiver.h
//  Bookmarks
//
//  Created by Akifumi Takata on 09/03/24.
//  Copyright 2009 Nursery-Framework. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATItem, ATBinder;

@interface ATBookmarksItemsArchiver : NSObject
{
	NSMutableSet *visitedItems;
	id root;
	ATBinder *source;
	NSMutableArray *enumerators;
	
	NSMutableDictionary *itemsPlist;
	NSMutableArray *toplevelItems;
	NSDictionary *itemsArchive;
}

+ (id)archiveItem:(ATItem *)anItem source:(ATBinder *)aSourceBinder;
+ (id)archiveItems:(NSArray *)anItems source:(ATBinder *)aSourceBinder;

- (id)initWithItems:(NSArray *)anItems source:(ATBinder *)aSourceBinder;

- (id)archive;
- (NSData *)dataWithArchivedItems;

- (void)convertRootToToplevelItems;
- (void)makeItemsArchive;

@end
