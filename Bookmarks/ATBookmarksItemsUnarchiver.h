//
//  BookmarksItemsUnarchiver.h
//  Bookmarks
//
//  Created by 高田 明史 on 09/03/26.
//  Copyright 2009 Pedophilia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATBinder;

@interface ATBookmarksItemsUnarchiver : NSObject
{
	NSDictionary *itemsArchive;
	NSMutableDictionary *unarchivedItems;
	NSMutableArray *toplevelItems;
}

+ (id)unarchive:(NSDictionary *)anArchive;

- (id)initWithArchive:(id)anArchive;

- (id)unarchive;

- (void)prepareUnarchivedItemsFromArchive;
- (void)establishBinders;
- (void)establishBinder:(ATBinder *)aBinder itemID:(NSNumber *)aBinderID;
- (id)toplevelItems;

@end
