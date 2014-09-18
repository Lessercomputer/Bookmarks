//
//  ATBookmarksUnarchiver.h
//  ATBookmarks
//
//  Created by 高田 明史 on 09/04/18.
//  Copyright 2009 Pedophilia. All rights reserved.
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
