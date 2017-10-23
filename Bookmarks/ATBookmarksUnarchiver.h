//
//  BookmarksUnarchiver.h
//  Bookmarks
//
//  Created by P,T,A on 09/04/18.
//  Copyright 2009 Nursery-Framework. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATItem, ATBinder, ATBookmarks, ATIDPool;

@interface ATBookmarksUnarchiver : NSObject
{
	NSDictionary *archivedBookmarks;
	
	NSMutableDictionary *unarchivedItems;
	NSMutableArray *binders;	
}

+ (id)unarchive:(NSDictionary *)anArchive;

- (id)initWithArchive:(id)anArchive;

- (id)unarchive;

- (void)prepareUnarchivedItems;
- (void)establishBinders;
- (void)establishBinder:(ATBinder *)aBinder children:(NSArray *)aChildren;
- (ATBookmarks *)makeBookmarks;
- (ATBinder *)rootBinder;
- (ATIDPool *)idPool;

@end
