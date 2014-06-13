//
//  ATBinder.h
//  ATBookmarks
//
//  Created by 明史 on 05/10/11.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "ATItem.h"


@interface ATBinder : ATItem
{
	NSMutableArray *children;
	BOOL isOpen;
}

@end

@interface ATBinder (Initializing)

+ (id)binder;

@end

@interface ATBinder (Accessing)

- (NSMutableArray *)children;
- (NSArray *)bookmarkItems;
- (void)setBookmarkItems:(NSArray *)anItems;

- (NSUInteger)count;
- (NSUInteger)countOfDescendant;

- (id)at:(NSUInteger)anIndex;
- (id)descendantAt:(unsigned *)anIndexRef;

- (id)atIndexPath:(NSIndexPath *)anIndexPath;

- (NSArray *)atIndexes:(NSIndexSet *)anIndexes;

- (NSUInteger)indexOf:(id)anItem;

- (NSIndexSet *)indexesOf:(NSArray *)anItems;

- (id)itemFor:(NSUInteger)anID;

@end

@interface ATBinder (ItemID)

- (void)itemIDFrom:(ATBookmarks *)aBookmarks;

- (void)restoreItemIDTo:(ATBookmarks *)aBookmarks;

- (void)releaseItemIDFrom:(ATBookmarks *)aBookmarks;

@end

@interface ATBinder (Enumerating)

- (NSEnumerator *)objectEnumerator;

- (void)makeObjectsPerformSelector:(SEL)aSelector;
- (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(id)anObject;

@end

@interface ATBinder (Modifying)
- (void)insert:(id)anItem at:(NSUInteger)anIndex on:(ATBookmarks *)aBookmarks;
- (void)remove:(id)anItem on:(ATBookmarks *)aBookmarks;

- (void)add:(id)anItem;
- (void)insert:(id)anItem at:(NSUInteger)anIndex;
- (void)insert:(NSArray *)anItems atIndexes:(NSIndexSet *)anIndexes;
- (void)remove:(id)anItem;
- (void)removeAtIndexes:(NSIndexSet *)anIndexes;
@end

@interface ATBinder (Testing)
- (BOOL)isOpen;
- (BOOL)setIsOpen:(BOOL)aFlag;
- (BOOL)isReachableFrom:(ATBinder *)aBinder;
@end

@interface ATBinder (Private)
- (void)setChildren:(NSMutableArray *)aChildren;
@end